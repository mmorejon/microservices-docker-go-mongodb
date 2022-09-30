terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.17.1"
    }
    argocd = {
      source = "oboukili/argocd"
      version = "3.2.1"
    }
  }
}

provider "argocd" {
  server_addr = "argocd.wayofthesys.org:443"
  username  = "admin"
  password  = var.argocd_oidc_client_secret
  insecure    = false
}

provider "digitalocean" {
  token   = var.do_token
}
