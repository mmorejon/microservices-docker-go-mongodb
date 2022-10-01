resource "github_repository_deploy_key" "argocd_repository_deploy_key" {
  title      = "ArgoCD Github Repo Public Key"
  repository = var.github_repo 
  key        = tls_private_key.argocd.public_key_openssh
  read_only  = "false"
}
