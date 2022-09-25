resource "kubernetes_ingress_v1" "argocd_ingress" {
  provider = kubernetes.cinema
  metadata {
    name      = "argocd-ingress"
    namespace = "argocd"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
     host = "argocd.wayofthesys.org"
      http {
        path {
          backend {
            name = "argocd-argo-cd-server"
            port = 80
          }

          path = "/"
        }
       }
      }
    }
  
  // tls {
  //  secret_name = "argocd-secret"
  // }
}

