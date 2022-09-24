resource "kubernetes_secret" "argocd-tls" {
  provider   = kubernetes.cinema
  depends_on = [digitalocean_kubernetes_cluster.cinema, helm_release.external-dns, kubernetes_namespace.cinema]
  metadata {
    name      = "${replace(var.domain_name[0], ".", "-")}-argocd-tls"
    namespace = "kube-argocd"
  }
  data = {
    "tls.crt" = tls_locally_signed_cert.cert.cert_pem
    "tls.key" = tls_private_key.key.private_key_pem
  }
}
