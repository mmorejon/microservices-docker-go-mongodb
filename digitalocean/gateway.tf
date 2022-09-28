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
            "argocd.wayofthesys.org",
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
            "argocd.wayofthesys.org",
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
