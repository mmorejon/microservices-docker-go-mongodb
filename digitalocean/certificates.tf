resource "kubernetes_manifest" "certificate_argo_argo" {
  provider = kubernetes.cinema
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "argocd-cert"
      "namespace" = "istio-system"
    }
    "spec" = {
      "commonName" = "argocd.${var.domain_name[0]}"
      "dnsNames" = [
        "argocd.${var.domain_name[0]}",
      ]
      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = "zerossl"
      }
      "secretName" = "argocd-tls"
    }
  }
}

resource "kubernetes_manifest" "certificate_cinema" {
  provider = kubernetes.cinema
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "cinema-cert"
      "namespace" = "istio-system"
    }
    "spec" = {
      "commonName" = var.domain_name[0]
      "dnsNames" = [
        var.domain_name[0],
      ]
      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = "zerossl"
      }
      "secretName" = "${replace(var.domain_name[0], ".", "-")}-tls"
    }
  }
}

resource "kubernetes_manifest" "certificate_locust" {
  provider = kubernetes.loadtesting
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "locust-cert"
      "namespace" = "istio-system"
    }
    "spec" = {
      "commonName" = "locust.${var.domain_name[0]}"
      "dnsNames" = [
        "locust.${var.domain_name[0]}",
      ]
      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = "zerossl"
      }
      "secretName" = "${replace(var.domain_name[0], ".", "-")}-tls"
    }
  }
}

/*
resource "kubernetes_manifest" "certificate_argo_istio" {
  provider = kubernetes.cinema
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "argocd-cert"
      "namespace" = "istio-system"
    }
    "spec" = {
      "commonName" = "argocd.${var.domain_name[0]}"
      "dnsNames" = [
        "argocd.${var.domain_name[0]}",
      ]
      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = "zerossl"
      }
      "secretName" = "${replace(var.domain_name[0], ".", "-")}-tls"
    }
  }
} */
