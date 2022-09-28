variable "do_token" {
  type        = string
  description = "Digital Ocean Token"
  default     = ""
}

variable "do_region" {
  type        = string
  description = "Digital Ocean Region"
  default     = "nyc3"
}

variable "domain_name" {
  type        = list 
  description = "Domain Name"
  default     = ["wayofthesys.org"]
}

variable "argocd_gitops_repo" {
  type        = string
  description = "ArgoCD GitOps Repo"
  default     = "https://github.com/autotune/microservices-docker-go-mongodb-tf"
}

variable "argocd_access_token" {
  type        = string
  description = "ArgoCD Access Token"
}


variable "argocd_oidc_name" {
  type        = string
  description = "ArgoCD OIDC Name"
  default     = "ArgoCD"
}

variable "argocd_oidc_issuer" {
  type        = string
  description = "ArgoCD OIDC Issuer"
  default     = "https://accounts.google.com"
}

variable "argocd_oidc_client_id" {
  type        = string
  description = "ArgoCD OIDC Client ID"
  default     = "argocd"
}

variable "argocd_oidc_client_secret" {
  type        = string
  description = "ArgoCD OIDC Client Secret"
}

variable "zerossl_email" {
  type        = string
  description = "ZeroSSL Email Address"
}

variable "zerossl_eab_hmac_key" {
  type        = string
  description = "ZeroSSL EAB HMAC KEY"
}

variable "zerossl_eab_hmac_key_id" {
  type        = string
  description = "ZeroSSL EAB HMAC KEY ID"
}
