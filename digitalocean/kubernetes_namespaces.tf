resource "kubernetes_namespace" "external-dns" {
  depends_on = [digitalocean_kubernetes_cluster.cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_namespace" "istio-system" {
  depends_on = [digitalocean_kubernetes_cluster.cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_namespace" "devingress" {
  depends_on = [digitalocean_kubernetes_cluster.cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "devingress"
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "kubernetes_namespace" "argocd" {
  depends_on = [digitalocean_kubernetes_cluster.cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "argocd"
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "kubernetes_namespace" "cert-manager" {
  depends_on = [digitalocean_kubernetes_cluster.cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "cinema" {
  depends_on = [digitalocean_kubernetes_cluster.cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "cinema"
    labels = {
      istio-injection = "enabled"
    }
  }
}
