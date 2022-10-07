locals {
  istio-repo    = "https://istio-release.storage.googleapis.com/charts"
  jetstack-repo = "https://charts.jetstack.io"
  bookinfo-repo = "https://evry-ace.github.io/helm-charts"
  argocd-repo   = "https://argoproj.github.io/argo-helm"
  robusta_global_sinks_config = yamlencode(
    {
      slack_sink = {
        "name"          = "main_slack_sink"
        "slack_channel" = "robusta-dev"
        "api_key"       = var.robusta_slack_api_key
      }
    }
  )
  argocd_dex_google = yamlencode(
    {
      server = {
        config = {
          "admin.enabled" = "true"
          "url"           = "https://argocd.${var.domain_name[0]}"
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
            }
          )
        }
      }
    }
  )
  argocd_dex_rbac = yamlencode(
    {
      server = {
        rbacConfig = {
          "policy.default" = "readOnly",
          "scopes"         = "[email]"
          "policy.csv" = replace(yamlencode(
            "g, autotune@contrasting.org, role:admin",
            ),
          "\"", "")
        }
      }
    }
  )
}
