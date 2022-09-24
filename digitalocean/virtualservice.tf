resource "kubernetes_manifest" "virtualservice_resource" {
  provider = kubernetes.cinema
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "VirtualService"
    "metadata" = {
      "name" = "argocd"
      "namespace"  = "kube-argocd"
    }
    }
    "spec" = {
      "gateways" = [
        "argocd-gateway",
      ]
      "hosts" = [
        "argocd.${var.domain_name[0]}",
      ]
      "http" = [
        {
          "route" = [
            {
              "destination" = {
                "host" = "argocd-server"
                "port" = {
                  "number" = 80
                }
              }
            },
          ]
        },
      ]
    }
  }
}
