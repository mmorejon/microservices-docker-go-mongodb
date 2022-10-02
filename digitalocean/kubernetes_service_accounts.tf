resource "kubernetes_service_account" "argocd_manager" {
  provider = kubernetes.cinema
  metadata {
    name      = "argocd-manager"
    namespace = "kube-system"
  }
  secret {
    name = kubernetes_secret.argocd_manager.metadata.0.name
  }
}
