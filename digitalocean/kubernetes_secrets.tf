resource "kubernetes_secret" "docker_login_secret" {
  provider   = kubernetes.cinema
  depends_on = [kubernetes_namespace.cinema]
  metadata {
    name      = "docker-login"
    namespace = "cinema"
  }

  data = {
    ".dockerconfigjson" : <<EOF
{
  "auths": {
    "ghcr.io": {
      "auth": "${base64encode("${var.gh_username}:${var.argocd_access_token}")}"
    }
  }
}
EOF
  }
  type = "kubernetes.io/dockerconfigjson"
}


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

resource "kubernetes_secret" "loadtesting_manager" {
  provider   = kubernetes.loadtesting 
  depends_on = [digitalocean_kubernetes_cluster.loadtesting, kubernetes_service_account.loadtesting_manager]
  metadata {
    name      = "loadtesting-manager"
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = "loadtesting-manager"
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_secret" "argocd-tls" {
  provider   = kubernetes.cinema
  depends_on = [digitalocean_kubernetes_cluster.cinema, helm_release.external-dns, kubernetes_namespace.cinema]
  metadata {
    name = "argocd-tls"
    # "${replace(var.domain_name[0], ".", "-")}-tls"
    namespace = "istio-system"
  }
  type = "tls"
  data = {
    "tls.crt" = tls_locally_signed_cert.cert.cert_pem
    "tls.key" = tls_private_key.key.private_key_pem
  }

  lifecycle {
    ignore_changes = [
      data,
      metadata
    ]
  }

}

resource "kubernetes_secret" "wayofthesys-tls" {
  provider   = kubernetes.cinema
  depends_on = [digitalocean_kubernetes_cluster.cinema, helm_release.external-dns, kubernetes_namespace.cinema]
  metadata {
    name      = "${replace(var.domain_name[0], ".", "-")}-tls"
    namespace = "istio-system"
  }
  type = "tls"
  data = {
    "tls.crt" = tls_locally_signed_cert.cert.cert_pem
    "tls.key" = tls_private_key.key.private_key_pem
  }

  lifecycle {
    ignore_changes = [
      data,
      metadata
    ]
  }

}

resource "kubernetes_secret" "wayofthesys-tls-loadtesting" {
  provider   = kubernetes.loadtesting
  depends_on = [digitalocean_kubernetes_cluster.loadtesting, helm_release.external-dns-loadtesting, kubernetes_namespace.loadtesting]
  metadata {
    name      = "${replace(var.domain_name[0], ".", "-")}-tls"
    namespace = "istio-system"
  }
  type = "tls"
  data = {
    "tls.crt" = tls_locally_signed_cert.cert.cert_pem
    "tls.key" = tls_private_key.key.private_key_pem
  }

  lifecycle {
    ignore_changes = [
      data,
      metadata
    ]
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

resource "kubernetes_secret" "zerossl-eab-hmac-key-loadtesting" {
  provider   = kubernetes.loadtesting
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

resource "kubernetes_secret" "zerossl-eab-hmac-key-id-loadtesting" {
  provider   = kubernetes.loadtesting
  depends_on = [digitalocean_kubernetes_cluster.loadtesting]
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

resource "kubernetes_secret" "digital-ocean-secret-loadtesting" {
  provider   = kubernetes.loadtesting
  depends_on = [digitalocean_kubernetes_cluster.loadtesting]
  metadata {
    name      = "digital-ocean-secret"
    namespace = "kube-system"
  }
  data = {
    token = base64encode(var.do_token)
  }
  type = "kubernetes.io/opaque"
}
