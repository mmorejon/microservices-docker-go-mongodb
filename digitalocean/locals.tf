locals {
  istio-repo    = "https://istio-release.storage.googleapis.com/charts"
  jetstack-repo = "https://charts.jetstack.io"
  bookinfo-repo = "https://evry-ace.github.io/helm-charts"
  argocd-repo   = "https://argoproj.github.io/argo-helm"
  argocd_dex_google = yamlencode(
    {
      server = {
        "config" = {
          rbacConfig = yamlencode(
            {
              policy.csv = [
                # Role definition : these users are admin
                "brian, autotune@contrasting.org, role:admin",
                {
                  policy.default = "",
                  scopes         = "[email, group]"
                }
              ]
          })
          "admin.enabled" = "true"
          "dex.config" = yamlencode(
            {
              connectors = [
                {
                  id   = "google"
                  type = "oidc"
                  name = "Google"
                  config = {
                    issuer       = "https://accounts.google.com"
                    clientID     = var.argocd_oidc_client_id
                    clientSecret = var.argocd_oidc_client_secret
                  }
                  requestedScopes = [
                    "-openid",
                    "-profile",
                    "-email"
                  ]
                }
              ]
              url : "https://argocd.${var.domain_name[0]}"
            }
          )
        }
      }
    }
  )
  argocd_dex_config_name = yamlencode(
    {
      server = {
        "config" = "dex.config"
      }
    }
  )
  argocd_dex_config_value = yamlencode(
    {
      connectors = [
        {
          id   = "google"
          type = "oidc"
          name = "Google"
          config = {
            clientID     = var.argocd_oidc_client_id
            clientSecret = var.argocd_oidc_client_secret
          }
        }
      ]
    }
  )
}
