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

resource "kubernetes_config_map" "argocd_cm" {
  provider = kubernetes.cinema
  metadata {
    name      = "argocd-cm"
    namespace = "argocd"

    labels = {
      "app.kubernetes.io/instance" = "argocd"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "argo-cd"

      "app.kubernetes.io/part-of" = "argocd"

      "helm.sh/chart" = "argo-cd-4.1.5"
    }

    annotations = {
      "meta.helm.sh/release-name" = "argocd"

      "meta.helm.sh/release-namespace" = "argocd"
    }
  }

  data = {
    "application.instanceLabelKey" = "argocd.argoproj.io/instance"

    "dex.config" = "connectors:\n- config:\n    issuer: https://accounts.google.com\n    clientID: sensitive(${var.argocd_oidc_client_id})\n    clientSecret: sensitive(${var.argocd_oidc_client_secret})\n  type: oidc\n  id: google\n  name: Google\n  requestedScopes:\n    - openid\n    - profile\n    - email\n"

    url = "https://argocd.${var.domain_name[0]}"
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
