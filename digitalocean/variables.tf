variable "do_token" {
  type        = string
  description = "Digital Ocean Token"
}

variable "do_region" {
  type        = string
  description = "Digital Ocean Region"
  default     = "nyc3"
}

variable "domain_name" {
  type        = list(any)
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
  sensitive   = true
}

variable "argocd_oidc_client_secret" {
  type        = string
  description = "ArgoCD OIDC Client Secret"
  sensitive   = true
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

variable "github_repo" {
  type        = string
  description = "GitHub Repository for ArgoCD deploy key"
  default     = "microservices-docker-go-mongodb-tf"
}

variable "gh_username" {
  type        = string
  description = "GitHub username for container registry"
}

variable "robusta_signing_key" {
  type        = string
  description = "Robusta Signing Key"
  sensitive   = true
}

variable "robusta_account_id" {
  type        = string
  description = "Robusta Account ID"
  sensitive   = true
}

variable "robusta_slack_api_key" {
  type        = string
  description = "Robusta Slack API Key"
  sensitive   = true
}

variable "robusta_ui_sink_token" {
  type        = string
  description = "Robusta Sink UI token "
  sensitive   = true
}

variable "robusta_rsa_public_key" {
  type        = string
  description = "Robusta Generated Public Key"
  sensitive   = true
}

variable "robusta_rsa_private_key" {
  type        = string
  description = "Robusta Generated Private Key"
  sensitive   = true
}
