variable "do_token" {
  type        = string
  description = "Digital Ocean Token"
}

variable "domain_name" {
  type        = list 
  description = "Domain Name"
  default     = ["wayofthesys.org"]
}

variable "argocd_oidc_secret" {
  type        = string
  description = "ArgoCD OIDC Secret"
}
