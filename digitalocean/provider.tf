terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.17.1"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = "3.2.1"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

data "kubernetes_secret" "argocd_admin" {
  depends_on = [helm_release.argocd]
  provider   = kubernetes.cinema
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
}

provider "argocd" {
  server_addr = "argocd.wayofthesys.org:443"
  insecure    = false
  username    = "admin"
  password    = data.kubernetes_secret.argocd_admin.data["password"]

  kubernetes {
    host  = digitalocean_kubernetes_cluster.cinema.endpoint
    token = digitalocean_kubernetes_cluster.cinema.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.cinema.kube_config[0].cluster_ca_certificate
    )
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "github" {
  token = var.argocd_access_token
}
