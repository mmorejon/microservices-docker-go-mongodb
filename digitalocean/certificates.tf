resource "kubernetes_manifest" "certificate_resource" {
  provider = kubernetes.cinema
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "argocd-cert"
      "namespace" = "cert-manager"
    }
    "spec" = {
      "commonName" = "*.${var.domain_name[0]}"
      "dnsNames" = [
        "*.${var.domain_name[0]}",
      ]
      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = "zerossl"
      }
      "secretName" = "${replace(var.domain_name[0], ".", "-")}-tls"
    }
  }
}
