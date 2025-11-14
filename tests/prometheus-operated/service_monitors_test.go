package prometheusoperated_test

import (
	"fmt"
	"os"
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/intstr"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	monitoringv1 "github.com/prometheus-operator/prometheus-operator/pkg/apis/monitoring/v1"
	promv1 "github.com/prometheus/client_golang/api/prometheus/v1"
)

var _ = Describe("ServiceMonitors", func() {
	// Target namespace for tests
	var targetNamespace string

	targetNamespace = os.Getenv("TEST_NAMESPACE")
	if targetNamespace == "" {
		targetNamespace = "monitoring"
	}

	Describe("Monitoring namespace ServiceMonitor discovery", func() {
		var serviceMonitors []monitoringv1.ServiceMonitor

		BeforeEach(func() {
			var err error
			serviceMonitors, err = getServiceMonitorsByNamespace(targetNamespace)
			Expect(err).NotTo(HaveOccurred(), "should list ServiceMonitors in %s namespace", targetNamespace)
		})

		It("should find at least one ServiceMonitor", func() {
			Expect(serviceMonitors).NotTo(BeEmpty(),
				"monitoring namespace should have ServiceMonitors deployed")
		})

		Context("when ServiceMonitors exist", func() {
			BeforeEach(func() {
				if len(serviceMonitors) == 0 {
					Skip("No ServiceMonitors found in monitoring namespace")
				}
			})

			It("should have valid configurations for all ServiceMonitors", func() {
				for _, sm := range serviceMonitors {
					By(fmt.Sprintf("Validating %s/%s", sm.Namespace, sm.Name))
					Expect(validateServiceMonitorConfiguration(sm)).To(Succeed(),
						"ServiceMonitor %s/%s should be valid", sm.Namespace, sm.Name)
				}
			})

			It("should have proper selectors configured", func() {
				for _, sm := range serviceMonitors {
					hasSelector := len(sm.Spec.Selector.MatchLabels) > 0 || len(sm.Spec.Selector.MatchExpressions) > 0
					Expect(hasSelector).To(BeTrue(),
						"ServiceMonitor %s/%s should have selector labels or expressions", sm.Namespace, sm.Name)
				}
			})

			It("should have at least one endpoint per ServiceMonitor", func() {
				for _, sm := range serviceMonitors {
					Expect(sm.Spec.Endpoints).NotTo(BeEmpty(),
						"ServiceMonitor %s/%s should have endpoints", sm.Namespace, sm.Name)
				}
			})

			It("should have valid endpoint configurations", func() {
				for _, sm := range serviceMonitors {
					By(fmt.Sprintf("Checking endpoints for %s/%s", sm.Namespace, sm.Name))
					for i, ep := range sm.Spec.Endpoints {
						hasPortConfig := ep.Port != "" || (ep.TargetPort != nil && ep.TargetPort.String() != "")
						Expect(hasPortConfig).To(BeTrue(),
							"ServiceMonitor %s/%s endpoint %d should have port or targetPort configured",
							sm.Namespace, sm.Name, i)
					}
				}
			})
		})
	})

	Describe("Prometheus target discovery", func() {
		BeforeEach(func() {
			if !prometheusReachable {
				Skip("Prometheus is not reachable, skipping target discovery tests")
			}
		})

		It("should successfully query Prometheus targets API", func(ctx SpecContext) {
			targets, err := promAPI.Targets(ctx)
			Expect(err).NotTo(HaveOccurred(), "Prometheus API should be accessible at %s", promAddress)
			Expect(targets).NotTo(BeNil())
		}, SpecTimeout(30*time.Second))

		It("should have all targets healthy for monitoring namespace ServiceMonitors", func(ctx SpecContext) {
			// Get all ServiceMonitors in monitoring namespace
			serviceMonitors, err := getServiceMonitorsByNamespace(targetNamespace)
			Expect(err).NotTo(HaveOccurred())

			if len(serviceMonitors) == 0 {
				Skip("No ServiceMonitors found in monitoring namespace")
			}

			// Get Prometheus targets
			targetsResult, err := promAPI.Targets(ctx)
			Expect(err).NotTo(HaveOccurred())

			// Map ServiceMonitor names for lookup
			serviceMonitorNames := make(map[string]bool)
			for _, sm := range serviceMonitors {
				serviceMonitorNames[sm.Name] = true
				GinkgoWriter.Printf("Found ServiceMonitor: %s/%s\n", sm.Namespace, sm.Name)
			}

			// Filter targets that belong to monitoring namespace ServiceMonitors
			monitoringTargets := filterTargetsByNamespace(targetsResult.Active, targetNamespace, serviceMonitorNames)

			// Report findings
			healthyCount := 0
			unhealthyCount := 0
			unhealthyTargets := []promv1.ActiveTarget{}

			for _, tgt := range monitoringTargets {
				if tgt.Health == "up" {
					healthyCount++
				} else {
					unhealthyCount++
					unhealthyTargets = append(unhealthyTargets, tgt)
					GinkgoWriter.Printf("❌ Unhealthy target: %s (job=%s, health=%s)\n   Error: %s\n",
						tgt.ScrapeURL, tgt.Labels["job"], tgt.Health, tgt.LastError)
				}
			}

			GinkgoWriter.Printf("\n📊 Monitoring namespace targets summary:\n")
			GinkgoWriter.Printf("   Total: %d\n", len(monitoringTargets))
			GinkgoWriter.Printf("   Healthy: %d\n", healthyCount)
			GinkgoWriter.Printf("   Unhealthy: %d\n", unhealthyCount)

			// Fail if there are any unhealthy targets
			if unhealthyCount > 0 {
				failureMsg := fmt.Sprintf("Found %d unhealthy targets in monitoring namespace:\n", unhealthyCount)
				for _, tgt := range unhealthyTargets {
					failureMsg += fmt.Sprintf("  - %s (job=%s): %s\n",
						tgt.ScrapeURL, tgt.Labels["job"], tgt.LastError)
				}
				Fail(failureMsg)
			}

			Expect(len(monitoringTargets)).To(BeNumerically(">", 0),
				"should have at least one target from monitoring namespace")
		}, SpecTimeout(30*time.Second))

		It("should eventually have all monitoring namespace targets healthy", func(ctx SpecContext) {
			Eventually(func(g Gomega) {
				// Get ServiceMonitors
				serviceMonitors, err := getServiceMonitorsByNamespace(targetNamespace)
				g.Expect(err).NotTo(HaveOccurred())

				if len(serviceMonitors) == 0 {
					Skip("No ServiceMonitors found in monitoring namespace")
				}

				// Get targets
				targetsResult, err := promAPI.Targets(ctx)
				g.Expect(err).NotTo(HaveOccurred())

				// Map ServiceMonitor names
				serviceMonitorNames := make(map[string]bool)
				for _, sm := range serviceMonitors {
					serviceMonitorNames[sm.Name] = true
				}

				// Filter and check
				monitoringTargets := filterTargetsByNamespace(targetsResult.Active, targetNamespace, serviceMonitorNames)

				unhealthyCount := 0
				for _, tgt := range monitoringTargets {
					if tgt.Health != "up" {
						unhealthyCount++
						GinkgoWriter.Printf("Still unhealthy: %s (job=%s) - %s\n",
							tgt.ScrapeURL, tgt.Labels["job"], tgt.LastError)
					}
				}

				g.Expect(unhealthyCount).To(Equal(0),
					"all monitoring namespace targets should eventually become healthy")
			}).WithTimeout(2 * time.Minute).
				WithPolling(10 * time.Second).
				Should(Succeed())
		}, SpecTimeout(10*time.Second))
	})

	Describe("ServiceMonitor validation rules", func() {
		DescribeTable("endpoint configuration",
			func(sm monitoringv1.ServiceMonitor, shouldBeValid bool) {
				err := validateServiceMonitorConfiguration(sm)
				if shouldBeValid {
					Expect(err).NotTo(HaveOccurred())
				} else {
					Expect(err).To(HaveOccurred())
				}
			},
			Entry("valid ServiceMonitor with port",
				monitoringv1.ServiceMonitor{
					ObjectMeta: metav1.ObjectMeta{
						Name:      "valid-sm",
						Namespace: "default",
					},
					Spec: monitoringv1.ServiceMonitorSpec{
						Selector: metav1.LabelSelector{
							MatchLabels: map[string]string{"app": "test"},
						},
						Endpoints: []monitoringv1.Endpoint{
							{Port: "metrics"},
						},
					},
				},
				true,
			),
			Entry("valid ServiceMonitor with targetPort",
				monitoringv1.ServiceMonitor{
					ObjectMeta: metav1.ObjectMeta{
						Name:      "valid-sm-targetport",
						Namespace: "default",
					},
					Spec: monitoringv1.ServiceMonitorSpec{
						Selector: metav1.LabelSelector{
							MatchLabels: map[string]string{"app": "test"},
						},
						Endpoints: []monitoringv1.Endpoint{
							{TargetPort: &intstr.IntOrString{Type: intstr.String, StrVal: "metrics"}},
						},
					},
				},
				true,
			),
			Entry("valid ServiceMonitor with matchExpressions",
				monitoringv1.ServiceMonitor{
					ObjectMeta: metav1.ObjectMeta{
						Name:      "valid-sm-expressions",
						Namespace: "default",
					},
					Spec: monitoringv1.ServiceMonitorSpec{
						Selector: metav1.LabelSelector{
							MatchExpressions: []metav1.LabelSelectorRequirement{
								{
									Key:      "app",
									Operator: metav1.LabelSelectorOpIn,
									Values:   []string{"test", "prod"},
								},
							},
						},
						Endpoints: []monitoringv1.Endpoint{
							{Port: "metrics"},
						},
					},
				},
				true,
			),
			Entry("invalid ServiceMonitor without name",
				monitoringv1.ServiceMonitor{
					ObjectMeta: metav1.ObjectMeta{
						Namespace: "default",
					},
					Spec: monitoringv1.ServiceMonitorSpec{
						Selector: metav1.LabelSelector{
							MatchLabels: map[string]string{"app": "test"},
						},
						Endpoints: []monitoringv1.Endpoint{
							{Port: "metrics"},
						},
					},
				},
				false,
			),
			Entry("invalid ServiceMonitor without namespace",
				monitoringv1.ServiceMonitor{
					ObjectMeta: metav1.ObjectMeta{
						Name: "no-namespace",
					},
					Spec: monitoringv1.ServiceMonitorSpec{
						Selector: metav1.LabelSelector{
							MatchLabels: map[string]string{"app": "test"},
						},
						Endpoints: []monitoringv1.Endpoint{
							{Port: "metrics"},
						},
					},
				},
				false,
			),
			Entry("invalid ServiceMonitor without selector",
				monitoringv1.ServiceMonitor{
					ObjectMeta: metav1.ObjectMeta{
						Name:      "no-selector",
						Namespace: "default",
					},
					Spec: monitoringv1.ServiceMonitorSpec{
						Selector: metav1.LabelSelector{},
						Endpoints: []monitoringv1.Endpoint{
							{Port: "metrics"},
						},
					},
				},
				false,
			),
			Entry("invalid ServiceMonitor without endpoints",
				monitoringv1.ServiceMonitor{
					ObjectMeta: metav1.ObjectMeta{
						Name:      "no-endpoints",
						Namespace: "default",
					},
					Spec: monitoringv1.ServiceMonitorSpec{
						Selector: metav1.LabelSelector{
							MatchLabels: map[string]string{"app": "test"},
						},
						Endpoints: []monitoringv1.Endpoint{},
					},
				},
				false,
			),
			Entry("invalid ServiceMonitor with endpoint missing port and targetPort",
				monitoringv1.ServiceMonitor{
					ObjectMeta: metav1.ObjectMeta{
						Name:      "endpoint-no-port",
						Namespace: "default",
					},
					Spec: monitoringv1.ServiceMonitorSpec{
						Selector: metav1.LabelSelector{
							MatchLabels: map[string]string{"app": "test"},
						},
						Endpoints: []monitoringv1.Endpoint{
							{Path: "/metrics"}, // Missing both Port and TargetPort
						},
					},
				},
				false,
			),
		)
	})
})

// Helper function to filter targets by namespace
func filterTargetsByNamespace(targets []promv1.ActiveTarget, namespace string, serviceMonitorNames map[string]bool) []promv1.ActiveTarget {
	var filtered []promv1.ActiveTarget

	for _, tgt := range targets {
		// Check if target belongs to the specified namespace
		// Targets from ServiceMonitors have these labels:
		// - namespace: the namespace of the target pod/service
		// - job: usually matches the ServiceMonitor name

		targetNamespace := tgt.Labels["namespace"]
		jobName := tgt.Labels["job"]

		// Match if:
		// 1. The target's namespace matches our target namespace, OR
		// 2. The job name matches one of our ServiceMonitor names
		if string(targetNamespace) == namespace || serviceMonitorNames[string(jobName)] {
			filtered = append(filtered, tgt)
		}
	}

	return filtered
}
