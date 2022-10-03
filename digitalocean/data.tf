data "kubernetes_secret" "argocd_manager" {
  depends_on = [kubernetes_secret.argocd_manager]
  provider   = kubernetes.cinema
  metadata {
    name      = "argocd-manager" # kubernetes_service_account.argocd_manager.default_secret_name
    namespace = "kube-system"
  }
}

data "kubernetes_secret" "loadtesting_manager" {
  depends_on = [kubernetes_secret.loadtesting_manager]
  provider   = kubernetes.loadtesting
  metadata {
    name      = "loadtesting-manager"
    namespace = "kube-system"
  }
}
