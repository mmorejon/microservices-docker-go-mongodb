resource "kubernetes_cluster_role_binding" "argocd_manager" {
  provider = kubernetes.cinema
  metadata {
    name = "argocd-manager-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.argocd_manager.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.argocd_manager.metadata.0.name
    namespace = kubernetes_service_account.argocd_manager.metadata.0.namespace
  }
}


resource "kubernetes_cluster_role_binding" "loadtesting_manager" {
  provider = kubernetes.loadtesting
  metadata {
    name = "loadtesting-manager-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.loadtesting_manager.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.loadtesting_manager.metadata.0.name
    namespace = kubernetes_service_account.loadtesting_manager.metadata.0.namespace
  }
}

