resource "kubernetes_namespace" "external-dns" {
  depends_on = [digitalocean_kubernetes_cluster.cinema]
  provider   = kubernetes.cinema
  metadata {
    name = "external-dns"
  }
}
