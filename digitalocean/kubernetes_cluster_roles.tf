resource "kubernetes_cluster_role" "argocd_manager" {
  provider = kubernetes.cinema
  metadata {
    name = "argocd-manager-role"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }

  rule {
    non_resource_urls = ["*"]
    verbs             = ["*"]
  }
}
