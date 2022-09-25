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

resource "kubernetes_secret" "zerossl-eab-hmac-key" {
  provider   = kubernetes.cinema
  depends_on = [digitalocean_kubernetes_cluster.cinema]
  metadata {
    name      = "zerossl-hmac-key"
    namespace = "kube-system"
  }
  data = {
    secret = var.zerossl_eab_hmac_key
  }
  type = "kubernetes.io/opaque"
}

resource "kubernetes_secret" "zerossl-eab-hmac-key-id" {
  provider   = kubernetes.cinema
  depends_on = [digitalocean_kubernetes_cluster.cinema]
  metadata {
    name      = "zerossl-hmac-key-id"
    namespace = "kube-system"
  }
  data = {
    secret = var.zerossl_eab_hmac_key_id
  }
  type = "kubernetes.io/opaque"
}
