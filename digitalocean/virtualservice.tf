resource "kubernetes_manifest" "virtualservice_resource" {
  provider = kubernetes.cinema
  manifest = {
  "apiVersion" = "networking.istio.io/v1beta1"
  "kind" = "VirtualService"
  "metadata" = {
    "name" = "argocd"
    "namespace" = "argocd"
  }
  "spec" = {
    "gateways" = [
      "argocd",
    ]
    "hosts" = [
      "argocd.${var.domain_name[0]}",
    ]
    "http" = [
      {
        "match" = [
          {
            "uri" = {
              "prefix" = "/"
            }
          },
        ]
        "route" = [
          {
            "destination" = {
              "host" = "argocd-argo-cd-server"
              "port" = {
                "number" = 443
              }
            }
          },
        ]
      },
    ]
  }
}
}
