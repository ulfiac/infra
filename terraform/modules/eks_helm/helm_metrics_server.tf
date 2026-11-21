resource "helm_release" "metrics_server" {
  chart      = "metrics-server"
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  version    = "3.14.0"
}
