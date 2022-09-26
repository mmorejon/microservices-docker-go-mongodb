resource "kubernetes_manifest" "argocd-gateway" {
  provider = kubernetes.cinema
  manifest = {
  "apiVersion" = "networking.istio.io/v1beta1"
  "kind" = "Gateway"
  "metadata" = {
    "name" = "argocd"
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
          "name" = "http"
          "number" = 80
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
