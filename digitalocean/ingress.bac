resource "kubernetes_ingress_v1" "argocd_ingress" {
  provider = kubernetes.cinema
  depends_on = [helm_release.cert-manager]
  metadata {
    name = "argocd-ingress"
    namespace = "argocd"
  }

  spec {
    ingress_class_name = "istio"
    default_backend {
      service {
        name = "argocd-argo-cd-server"
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
              name = "argocd-argo-cd-server"
              port {
                number = 80
              }
            }
          }

          path = "/"
        }
      }
    }

    tls {
      secret_name = "argocd-secret"
    }
  }
}

