resource "kubernetes_manifest" "argocd-gateway" {
  provider = kubernetes.cinema
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "Gateway"
    "metadata" = {
      "name"      = "argocd"
      "namespace" = "argocd"
    }
    "spec" = {
      "selector" = {
        "istio" = "ingressgateway"
      }
      "servers" = [
        {
          "hosts" = [
            "argocd.${var.domain_name[0]}",
          ]
          "port" = {
            "name"     = "http"
            "number"   = 80
            "protocol" = "HTTP"
          }
          "tls" = {
            "httpsRedirect" = false
          }
        },
        {
          "hosts" = [
            "argocd.${var.domain_name[0]}",
          ]
          "port" = {
            "name"     = "https"
            "number"   = 443
            "protocol" = "HTTPS"
          }
          "tls" = {
            "credentialName"    = "argocd-tls"
            "mode"              = "SIMPLE"
            "serverCertificate" = "/etc/istio/ingressgateway-certs/tls.crt"
            "privateKey"        = "/etc/istio/ingressgateway-certs/tls.key"
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "cinema-gateway" {
  depends_on = [helm_release.argocd]
  provider   = kubernetes.cinema
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "Gateway"
    "metadata" = {
      "name"      = "cinema"
      "namespace" = "cinema"
    }
    "spec" = {
      "selector" = {
        "istio" = "ingressgateway"
      }
      "servers" = [
        {
          "hosts" = [
            "${var.domain_name[0]}",
          ]
          "port" = {
            "name"     = "http"
            "number"   = 80
            "protocol" = "HTTP"
          }
          "tls" = {
            "httpsRedirect" = false
          }
        },
        {
          "hosts" = [
            "${var.domain_name[0]}",
          ]
          "port" = {
            "name"     = "https"
            "number"   = 443
            "protocol" = "HTTPS"
          }
          "tls" = {
            "credentialName"    = "${replace(var.domain_name[0], ".", "-")}-tls"
            "mode"              = "SIMPLE"
            "serverCertificate" = "/etc/istio/ingressgateway-certs/tls.crt"
            "privateKey"        = "/etc/istio/ingressgateway-certs/tls.key"
          }
        },
      ]
    }
  }
}
