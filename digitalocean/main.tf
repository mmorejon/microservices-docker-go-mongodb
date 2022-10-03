provider "helm" {
  kubernetes {
    host                   = digitalocean_kubernetes_cluster.cinema.endpoint
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.cinema.kube_config[0].cluster_ca_certificate)
    token                  = digitalocean_kubernetes_cluster.cinema.kube_config[0].token
  }
  alias = "cinema"
}

provider "helm" {
  kubernetes {
    host                   = digitalocean_kubernetes_cluster.loadtesting.endpoint
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.loadtesting.kube_config[0].cluster_ca_certificate)
    token                  = digitalocean_kubernetes_cluster.loadtesting.kube_config[0].token
  }
  alias = "loadtesting"
}

provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.cinema.endpoint
  token = digitalocean_kubernetes_cluster.cinema.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.cinema.kube_config[0].cluster_ca_certificate
  )
  alias = "cinema"
}

provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.loadtesting.endpoint
  token = digitalocean_kubernetes_cluster.loadtesting.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.loadtesting.kube_config[0].cluster_ca_certificate
  )
  alias = "loadtesting"
}
