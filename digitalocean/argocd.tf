resource "argocd_cluster" "do-cinema" {
  provider   = argocd
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

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    description  = "Cinema"
    source_repos = ["https://github.com/autotune/microservices-docker-go-mongodb-tf", "https://kedacore.github.io/charts", "https://robusta-charts.storage.googleapis.com"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "cinema"
    }
    destination {
      server    = digitalocean_kubernetes_cluster.cinema.endpoint
      namespace = "cinema"
    }
    destination {
      server    = digitalocean_kubernetes_cluster.cinema.endpoint
      namespace = "kube-system"
    }
    destination {
      server    = digitalocean_kubernetes_cluster.cinema.endpoint
      namespace = "loadtesting"
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

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    description  = "loadtesting"
    source_repos = ["https://github.com/autotune/loadtesting", "https://kedacore.github.io/charts"]

    destination {
      server    = digitalocean_kubernetes_cluster.loadtesting.endpoint
      namespace = "loadtesting"
    }

    destination {
      server    = digitalocean_kubernetes_cluster.loadtesting.endpoint
      namespace = "kube-system"
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

resource "argocd_application" "cinema-robusta" {
  depends_on = [argocd_project.cinema]
  provider   = argocd
  metadata {
    name      = "robusta"
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
        release_name = "robusta"

        parameter {
          name  = "globalConfig.signing_key"
          value = var.robusta_signing_key
        }

        parameter {
          name  = "clusterName"
          value = "cinema"
        }

        parameter {
          name  = "globalConfig.account_key"
          value = var.robusta_account_id
        }

        parameter {
          name  = "sinksConfig[0].slack_sink.name"
          value = "main_slack_sink"
        }

        parameter {
          name  = "sinksConfig[0].slack_sink.slack_channel"
          value = "robusta-dev"
        }

        parameter {
          name  = "sinksConfig[0].slack_sink.api_key"
          value = var.robusta_slack_api_key
        }

        parameter {
          name  = "sinksConfig[0].robusta_sink.name"
          value = "robusta_ui_sink"
        }

        parameter {
          name  = "sinksConfig[0].robusta_sink.token"
          value = var.robusta_ui_sink_token 
        }

        parameter {
          name  = "rsa.pub"
          value = var.robusta_rsa_public_key
        }

        parameter {
          name  = "rsa.prv"
          value = var.robusta_rsa_private_key
        }

      }

      repo_url        = "https://robusta-charts.storage.googleapis.com"
      chart           = "robusta"
      target_revision = "0.10.6"
    }
    destination {
      server    = digitalocean_kubernetes_cluster.cinema.endpoint
      namespace = "cinema"
    }
  }
}

resource "argocd_application" "cinema-keda" {
  depends_on = [argocd_project.cinema]
  metadata {
    name      = "cinema-keda"
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
        release_name = "keda"
      }
      repo_url        = "https://kedacore.github.io/charts"
      chart           = "keda"
      target_revision = "2.8.2"
    }
    destination {
      server    = digitalocean_kubernetes_cluster.cinema.endpoint
      namespace = "cinema"
    }
  }
}

resource "argocd_application" "keda-loadtesting" {
  depends_on = [argocd_project.loadtesting]
  metadata {
    name      = "keda-loadtesting"
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
        release_name = "keda"
      }
      repo_url        = "https://kedacore.github.io/charts"
      chart           = "keda"
      target_revision = "2.8.2"
    }
    destination {
      server    = digitalocean_kubernetes_cluster.loadtesting.endpoint
      namespace = "loadtesting"
    }
  }
}

resource "argocd_application" "keda-scaledobject-cinema" {
  depends_on = [argocd_application.cinema-keda]
  metadata {
    name      = "keda-cron"
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
        release_name = "keda-cron"
        parameter {
          name  = "keda.name"
          value = "cinema"
        }
        parameter {
          name  = "keda.namespace"
          value = "cinema"
        }
        parameter {
          name  = "keda.scaletargetname"
          value = "cinema"
        }
      }
      repo_url        = "https://github.com/autotune/microservices-docker-go-mongodb-tf"
      target_revision = "main"
      path            = "charts/keda"
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
