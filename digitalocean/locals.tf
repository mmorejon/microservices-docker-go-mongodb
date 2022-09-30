locals {
  istio-repo    = "https://istio-release.storage.googleapis.com/charts"
  jetstack-repo = "https://charts.jetstack.io"
  bookinfo-repo = "https://evry-ace.github.io/helm-charts"
  argocd-repo   = "https://argoproj.github.io/argo-helm"
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
          id   = "github"
          type = "github"
          name = "Github"
        }
      ]
    }
  )
}
