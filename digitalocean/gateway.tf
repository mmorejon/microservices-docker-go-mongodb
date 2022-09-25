resource "kubernetes_manifest" "gateway_resource" {
  provider   = kubernetes.cinema
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "Gateway"
    "metadata" = {
      "name"       = "argocd-gateway"
      "namespace"  = "argocd"
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
            "name"     = "https"
            "number"   = 443
            "protocol" = "HTTPS"
          }
          "tls" = {
            "credentialName" = "argocd-secret"
            "mode"           = "SIMPLE"
          }
        },
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
      ]
    }
  }
}
