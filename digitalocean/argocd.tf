resource "argocd_cluster" "do-cinema" {
  server     = digitalocean_kubernetes_cluster.cinema.endpoint
  name       = "do-cinema"
  depends_on = [helm_release.argocd]

  config {
    bearer_token = data.kubernetes_secret.argocd_manager.data["token"]
    tls_client_config {
      ca_data = data.kubernetes_secret.argocd_manager.data["ca.crt"]
      // cert_data = base64decode(digitalocean_kubernetes_cluster.cinema.kube_config[0].client_certificate)
      // key_data = base64decode(digitalocean_kubernetes_cluster.cinema.kube_config[0].client_key)
    }
  }
}

resource "argocd_repository_credentials" "cinema" {
  depends_on      = [helm_release.argocd]
  url             = "git@github.com:autotune/microservices-docker-go-mongodb-tf.git"
  username        = "git"
  ssh_private_key = tls_private_key.argocd.private_key_openssh
}

resource "argocd_application" "cinema" {
  metadata {
    name      = "cinema"
    namespace = "cinema"
    labels = {
      env = "dev"
    }
  }

  wait = true

  spec {
    source {
      helm {
        release_name = "cinema-v1.0.0"
      }
      repo_url        = "git@github.com/autotune/microservices-docker-go-mongodb-tf.git"
      path            = "charts/cinema"
      chart           = "cinema"
      target_revision = "digitalocean"
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "default"
    }
  }
}
