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

resource "kubernetes_service_account" "loadtesting_manager" {
  provider = kubernetes.loadtesting 
  metadata {
    name      = "loadtesting-manager"
    namespace = "kube-system"
  }
}
