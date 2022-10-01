resource "github_user_ssh_key" "argocd" {
  title = "argocd"
  key   = tls_private_key.argocd.public_key_openssh
}
