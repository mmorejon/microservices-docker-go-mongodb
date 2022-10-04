resource "argocd_cluster" "do-cinema" {
  server     = digitalocean_kubernetes_cluster.cinema.endpoint
  name       = "do-cinema"
  depends_on = [helm_release.argocd]

  config {
    bearer_token = data.kubernetes_secret.argocd_manager.data["token"]
    tls_client_config {
      ca_data = data.kubernetes_secret.argocd_manager.data["ca.crt"]
    }
  }
}

resource "argocd_cluster" "do-loadtesting" {
  server     = digitalocean_kubernetes_cluster.loadtesting.endpoint
  name       = "do-loadtesting"
  depends_on = [helm_release.argocd]

  config {
    bearer_token = data.kubernetes_secret.loadtesting_manager.data["token"]
    tls_client_config {
      ca_data = data.kubernetes_secret.loadtesting_manager.data["ca.crt"]
    }
  }
}

resource "argocd_repository_credentials" "cinema" {
  depends_on      = [helm_release.argocd]
  url             = "git@github.com:autotune/microservices-docker-go-mongodb-tf.git"
  username        = "git"
  ssh_private_key = tls_private_key.argocd.private_key_openssh
}

resource "argocd_project" "cinema" {
  depends_on = [helm_release.argocd]
  metadata {
    name      = "cinema"
    namespace = "argocd"
    labels = {
      environment = "dev"
    }
  }

  spec {
    description  = "Cinema"
    source_repos = ["https://github.com/autotune/microservices-docker-go-mongodb-tf"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "cinema"
    }
    destination {
      server    = digitalocean_kubernetes_cluster.cinema.endpoint
      namespace = "cinema"
    }
  }
}

resource "argocd_project" "loadtesting" {
  depends_on = [helm_release.argocd]
  metadata {
    name      = "loadtesting"
    namespace = "argocd"
    labels = {
      environment = "dev"
    }
  }

  spec {
    description  = "loadtesting"
    source_repos = ["https://github.com/autotune/loadtesting"]

    destination {
      server    = digitalocean_kubernetes_cluster.loadtesting.endpoint
      namespace = "loadtesting"
    }
  }
}

resource "argocd_application" "cinema" {
  depends_on = [argocd_project.cinema]
  metadata {
    name      = "cinema"
    namespace = "argocd"
    labels = {
      env = "dev"
    }
  }

  wait = true

  spec {
    project = "cinema"
    source {
      helm {
        release_name = "cinema"
      }
      repo_url        = "https://github.com/autotune/microservices-docker-go-mongodb-tf"
      path            = "charts/cinema"
      target_revision = "main"
    }
    destination {
      server    = digitalocean_kubernetes_cluster.cinema.endpoint
      namespace = "cinema"
    }
  }
}

resource "argocd_application" "locust" {
  depends_on = [argocd_project.cinema]
  metadata {
    name      = "locus"
    namespace = "argocd"
    labels = {
      env = "dev"
    }
  }

  wait = true

  spec {
    project = "loadtesting"
    source {
      helm {
        release_name = "locust"
      }
      repo_url        = "https://github.com/autotune/loadtesting"
      path            = "stable/locust"
      target_revision = "master"
    }
    destination {
      server    = digitalocean_kubernetes_cluster.loadtesting.endpoint
      namespace = "loadtesting"
    }
  }
}
