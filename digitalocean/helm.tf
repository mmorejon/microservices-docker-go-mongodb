resource "helm_release" "external-dns" {
  provider   = helm.cinema
  depends_on = [digitalocean_kubernetes_cluster.cinema, kubernetes_namespace.external-dns]
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "v6.9.0"
  namespace  = "external-dns"
  timeout    = 120
  set {
    name  = "provider"
    value = "digitalocean"
  }
  set {
    name  = "digitalocean.apiToken"
    value = var.do_token 
  }
  set {
    name  = "rbac.create"
    value = "true"
  }
  set {
    name  = "domainFilters"
    value = "{${var.domain_name[0]}}"
  }
  set {
    name  = "sources"
    value = "{ingress,service}"
  }
}
