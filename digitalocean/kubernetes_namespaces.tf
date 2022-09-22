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
