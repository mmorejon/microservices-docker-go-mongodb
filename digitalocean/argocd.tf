module "argocd" {
  source  = "git::https://github.com/autotune/terraform-kubernetes-argocd" # ?ref=argocd-tls-disabled"

  depends_on = [digitalocean_kubernetes_cluster.cinema, kubernetes_namespace.external-dns, kubernetes_namespace.argocd]

  providers = {
    kubernetes = kubernetes.cinema
  }

  namespace              = "kube-argocd"
  argocd_server_replicas = 2
  argocd_repo_replicas   = 2
  enable_dex             = false
  labels                 = { "istio-injection" = "enabled"}
  ingress_enabled    = false 
  ingress_host       = "argocd.${var.domain_name[0]}"
  ingress_path       = "/"
  ingress_class_name = "nginx"
  ingress_cert_issuer_annotation = {
    "kubernetes.io/ingress.class" : "nginx"
    "cert-manager.io/cluster-issuer" : "ZeroSSL"
  }
  argocd_server_requests = {
    cpu = "300m"
    memory = "256Mi"
  }
  argocd_server_limits = {
    cpu = "600m"
    memory = "512Mi"
  }

  repo_server_exec_timeout = "300"
  argocd_repo_requests = {
    cpu = "300m"
    memory = "256Mi"
  }
  argocd_repo_limits = {
    cpu = "600m"
    memory = "512Mi"
  }
  argocd_repositories = [
    {
      name = "Helm-Main"
      type = "helm"
      url = "https://charts.helm.sh/stable"
    }
  ]

  oidc_config = {
    name                      = var.argocd_oidc_name
    issuer                    = var.argocd_oidc_issuer
    client_id                 = var.argocd_oidc_client_id
    client_secret             = var.argocd_oidc_client_secret
    requested_id_token_claims = tomap({})
    requested_scopes          = ["openid"]
  }
} 
