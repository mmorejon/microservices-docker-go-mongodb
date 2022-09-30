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

resource "kubernetes_secret" "argocd_manager" {
  provider   = kubernetes.cinema
  depends_on = [digitalocean_kubernetes_cluster.cinema]
  metadata {
    name      = "argocd-manager"
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = "argocd-manager"
    }
  }
  type = "kubernetes.io/service-account-token"
}

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

data "kubernetes_secret" "argocd_manager" {
  depends_on = [kubernetes_secret.argocd_manager]
  provider = kubernetes.cinema
  metadata {
    name      = "argocd-manager" # kubernetes_service_account.argocd_manager.default_secret_name
    namespace = "kube-system"
  }
}

/*
resource "argocd_cluster" "do-cinema" {
  server = digitalocean_kubernetes_cluster.cinema.endpoint
  name   = "do-cinema"

  config {
    bearer_token = digitalocean_kubernetes_cluster.cinema.kube_config[0].token 
    # data.kubernetes_secret.argocd_manager.data["token"]
    tls_client_config {
      ca_data = base64decode(digitalocean_kubernetes_cluster.cinema.kube_config[0].cluster_ca_certificate)
      cert_data = base64decode(digitalocean_kubernetes_cluster.cinema.kube_config[0].client_certificate)
      key_data = base64decode(digitalocean_kubernetes_cluster.cinema.kube_config[0].client_key)
    }
  }
}*/
