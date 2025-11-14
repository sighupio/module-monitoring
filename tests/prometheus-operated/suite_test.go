package prometheusoperated_test

import (
	"context"
	"flag"
	"fmt"
	"net/http"
	"net/url"
	"os"
	"testing"
	"time"

	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/tools/portforward"
	"k8s.io/client-go/transport/spdy"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	monitoringv1 "github.com/prometheus-operator/prometheus-operator/pkg/apis/monitoring/v1"
	monclientset "github.com/prometheus-operator/prometheus-operator/pkg/client/versioned"
	"github.com/prometheus/client_golang/api"
	promv1 "github.com/prometheus/client_golang/api/prometheus/v1"
)

func TestPrometheusOperated(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Prometheus Operated Suite")
}

// Shared test clients and context
var (
	k8sClient           *kubernetes.Clientset
	monClient           *monclientset.Clientset
	promAPI             promv1.API
	promAddress         string
	testCtx             context.Context
	prometheusReachable bool
	kubeConfig          *rest.Config

	// Port forwarding
	portForwarder       *portforward.PortForwarder
	stopChan            chan struct{}
	readyChan           chan struct{}
	localPrometheusPort int
)

var _ = BeforeSuite(func() {
	testCtx = context.Background()
	localPrometheusPort = 9090 // Default local port

	var err error
	kubeConfig, err = buildKubeConfig()
	Expect(err).NotTo(HaveOccurred(), "should build kubeconfig")

	k8sClient, err = kubernetes.NewForConfig(kubeConfig)
	Expect(err).NotTo(HaveOccurred(), "should create kubernetes client")

	monClient, err = monclientset.NewForConfig(kubeConfig)
	Expect(err).NotTo(HaveOccurred(), "should create monitoring client")

	// Check if we should set up port forwarding
	promAddress = os.Getenv("PROMETHEUS_ADDRESS")
	if promAddress == "" {
		// No explicit address provided, try to set up port forwarding
		GinkgoWriter.Println("No PROMETHEUS_ADDRESS set, attempting to set up port-forward...")

		if setupPortForward() {
			promAddress = fmt.Sprintf("http://localhost:%d", localPrometheusPort)
			GinkgoWriter.Printf("Port-forward established to localhost:%d\n", localPrometheusPort)
		} else {
			// Fallback to in-cluster address
			promAddress = "http://prometheus-operated.monitoring.svc.cluster.local:9090"
			GinkgoWriter.Println("Port-forward failed, using in-cluster address")
		}
	}

	promClient, err := api.NewClient(api.Config{Address: promAddress})
	Expect(err).NotTo(HaveOccurred(), "should create Prometheus client")

	promAPI = promv1.NewAPI(promClient)

	// Check if Prometheus is reachable
	prometheusReachable = checkPrometheusReachability()

	GinkgoWriter.Printf("Prometheus Operated test suite initialized\n")
	GinkgoWriter.Printf("Prometheus Address: %s\n", promAddress)
	GinkgoWriter.Printf("Prometheus Reachable: %v\n", prometheusReachable)
})

var _ = AfterSuite(func() {
	// Clean up port-forward if it was created
	if stopChan != nil {
		GinkgoWriter.Println("Stopping port-forward...")
		close(stopChan)
	}

	if portForwarder != nil {
		// Give it a moment to clean up
		time.Sleep(100 * time.Millisecond)
	}

	GinkgoWriter.Println("Prometheus Operated test suite cleanup completed")
})

// Helper functions

func buildKubeConfig() (*rest.Config, error) {
	var kubeconfigFlag string
	if f := flag.Lookup("kubeconfig"); f != nil {
		kubeconfigFlag = f.Value.String()
	}

	if kubeconfigFlag != "" {
		return clientcmd.BuildConfigFromFlags("", kubeconfigFlag)
	}

	if path := os.Getenv("KUBECONFIG"); path != "" {
		return clientcmd.BuildConfigFromFlags("", path)
	}

	return rest.InClusterConfig()
}

func setupPortForward() bool {
	// Configuration
	namespace := os.Getenv("PROMETHEUS_NAMESPACE")
	if namespace == "" {
		namespace = "monitoring"
	}

	serviceName := os.Getenv("PROMETHEUS_SERVICE")
	if serviceName == "" {
		serviceName = "prometheus-operated"
	}

	servicePort := os.Getenv("PROMETHEUS_SERVICE_PORT")
	if servicePort == "" {
		servicePort = "9090"
	}

	// Find a pod for the service
	podName, err := findPrometheusPod(namespace, serviceName)
	if err != nil {
		GinkgoWriter.Printf("Failed to find Prometheus pod: %v\n", err)
		return false
	}

	GinkgoWriter.Printf("Found Prometheus pod: %s in namespace: %s\n", podName, namespace)

	// Set up port forwarding
	path := fmt.Sprintf("/api/v1/namespaces/%s/pods/%s/portforward", namespace, podName)

	// Parse the host URL
	hostURL, err := url.Parse(kubeConfig.Host)
	if err != nil {
		GinkgoWriter.Printf("Failed to parse host URL: %v\n", err)
		return false
	}

	// Construct the full URL for port forwarding
	portForwardURL := &url.URL{
		Scheme: hostURL.Scheme,
		Host:   hostURL.Host,
		Path:   path,
	}

	transport, upgrader, err := spdy.RoundTripperFor(kubeConfig)
	if err != nil {
		GinkgoWriter.Printf("Failed to create round tripper: %v\n", err)
		return false
	}

	dialer := spdy.NewDialer(upgrader, &http.Client{Transport: transport}, http.MethodPost, portForwardURL)

	stopChan = make(chan struct{}, 1)
	readyChan = make(chan struct{}, 1)

	ports := []string{fmt.Sprintf("%d:%s", localPrometheusPort, servicePort)}

	portForwarder, err = portforward.New(dialer, ports, stopChan, readyChan,
		GinkgoWriter, GinkgoWriter)
	if err != nil {
		GinkgoWriter.Printf("Failed to create port forwarder: %v\n", err)
		return false
	}

	// Start port forwarding in a goroutine
	go func() {
		if err := portForwarder.ForwardPorts(); err != nil {
			GinkgoWriter.Printf("Port forward error: %v\n", err)
		}
	}()

	// Wait for port forward to be ready with timeout
	select {
	case <-readyChan:
		GinkgoWriter.Println("Port forward is ready")
		// Give it a moment to fully establish
		time.Sleep(500 * time.Millisecond)
		return true
	case <-time.After(10 * time.Second):
		GinkgoWriter.Println("Timeout waiting for port forward to be ready")
		close(stopChan)
		return false
	}
}

func findPrometheusPod(namespace, serviceName string) (string, error) {
	// First, try to get the service to find the selector
	svc, err := k8sClient.CoreV1().Services(namespace).Get(testCtx, serviceName, metav1.GetOptions{})
	if err != nil {
		return "", fmt.Errorf("getting service: %w", err)
	}

	// Use the service selector to find pods
	labelSelector := metav1.FormatLabelSelector(&metav1.LabelSelector{
		MatchLabels: svc.Spec.Selector,
	})

	pods, err := k8sClient.CoreV1().Pods(namespace).List(testCtx, metav1.ListOptions{
		LabelSelector: labelSelector,
		FieldSelector: "status.phase=Running",
	})
	if err != nil {
		return "", fmt.Errorf("listing pods: %w", err)
	}

	if len(pods.Items) == 0 {
		return "", fmt.Errorf("no running pods found for service %s", serviceName)
	}

	// Return the first running pod
	for _, pod := range pods.Items {
		if pod.Status.Phase == corev1.PodRunning {
			return pod.Name, nil
		}
	}

	return "", fmt.Errorf("no running pods found")
}

func checkPrometheusReachability() bool {
	ctx, cancel := context.WithTimeout(testCtx, 10*time.Second)
	defer cancel()

	_, err := promAPI.Targets(ctx)
	if err != nil {
		GinkgoWriter.Printf("Prometheus not reachable: %v\n", err)
		return false
	}
	return true
}

func getAllServiceMonitors() ([]monitoringv1.ServiceMonitor, error) {
	smList, err := monClient.MonitoringV1().ServiceMonitors("").List(testCtx, metav1.ListOptions{})
	if err != nil {
		return nil, fmt.Errorf("listing ServiceMonitors: %w", err)
	}
	return smList.Items, nil
}

func validateServiceMonitorConfiguration(sm monitoringv1.ServiceMonitor) error {
	if sm.Name == "" {
		return fmt.Errorf("ServiceMonitor has no name")
	}
	if sm.Namespace == "" {
		return fmt.Errorf("ServiceMonitor %s has no namespace", sm.Name)
	}
	if sm.Spec.Selector.MatchLabels == nil && len(sm.Spec.Selector.MatchExpressions) == 0 {
		return fmt.Errorf("ServiceMonitor %s/%s has no selector", sm.Namespace, sm.Name)
	}
	if len(sm.Spec.Endpoints) == 0 {
		return fmt.Errorf("ServiceMonitor %s/%s has no endpoints", sm.Namespace, sm.Name)
	}
	for i, ep := range sm.Spec.Endpoints {
		if ep.Port == "" && (ep.TargetPort == nil || ep.TargetPort.String() == "") {
			return fmt.Errorf("ServiceMonitor %s/%s endpoint %d has neither port nor targetPort set",
				sm.Namespace, sm.Name, i)
		}
	}
	return nil
}

func getServiceMonitorsByNamespace(namespace string) ([]monitoringv1.ServiceMonitor, error) {
	smList, err := monClient.MonitoringV1().ServiceMonitors(namespace).List(testCtx, metav1.ListOptions{})
	if err != nil {
		return nil, fmt.Errorf("listing ServiceMonitors in namespace %s: %w", namespace, err)
	}
	return smList.Items, nil
}
