resource "kubernetes_secret" "argocd_manager" {
  provider   = kubernetes.cinema
  depends_on = [digitalocean_kubernetes_cluster.cinema]
  metadata {
    name      = "argocd-manager"
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = "argocd-manager"
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_secret" "argocd-tls" {
  provider   = kubernetes.cinema
  depends_on = [digitalocean_kubernetes_cluster.cinema, helm_release.external-dns, kubernetes_namespace.cinema]
  metadata {
    name      = "argo-cert"
    # "${replace(var.domain_name[0], ".", "-")}-tls"
    namespace = "istio-system"
  }
  type = "tls"
  data = {
    "tls.crt" = tls_locally_signed_cert.cert.cert_pem
    "tls.key" = tls_private_key.key.private_key_pem
  }
}

resource "kubernetes_secret" "zerossl-eab-hmac-key" {
  provider   = kubernetes.cinema
  depends_on = [digitalocean_kubernetes_cluster.cinema]
  metadata {
    name      = "zerossl-eab-hmac-key"
    namespace = "cert-manager"
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
    name      = "zerossl-eab-hmac-key-id"
    namespace = "cert-manager"
  }
  data = {
    secret = var.zerossl_eab_hmac_key_id
  }
  type = "kubernetes.io/opaque"
}

resource "kubernetes_secret" "digital-ocean-secret" {
  provider   = kubernetes.cinema
  depends_on = [digitalocean_kubernetes_cluster.cinema]
  metadata {
    name      = "digital-ocean-secret"
    namespace = "kube-system"
  }
  data = {
    token = base64encode(var.do_token)
  }
  type = "kubernetes.io/opaque"
}
