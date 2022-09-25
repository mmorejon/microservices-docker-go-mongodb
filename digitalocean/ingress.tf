resource "kubernetes_ingress_v1" "argocd_ingress" {
  provider = kubernetes.cinema
  metadata {
    name = "argocd-ingress"
    namespace = "argocd"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    default_backend {
      service {
        name = "argocd"
        port {
          number = 80
        }
      }
    }

    rule {
      host = "argocd.${var.domain_name[0]}"
      http {
        path {
          backend {
            service {
              name = "argocd-argo-cd-serve"
              port {
                number = 80
              }
            }
          }

          path = "/*"
        }
      }
    }

    # tls {
    #   secret_name = "tls-secret"
    # }
  }
}

