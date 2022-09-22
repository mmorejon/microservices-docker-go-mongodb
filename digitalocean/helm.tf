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

resource "helm_release" "istio-base" {
  provider        = helm.cinema
  repository      = local.istio-repo
  name            = "istio-base"
  chart           = "base"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name
  depends_on      = [kubernetes_namespace.istio-system]
}

resource "helm_release" "istiod" {
  provider        = helm.cinema
  repository      = local.istio-repo
  name            = "istiod"
  chart           = "istiod"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name
  set {
    name  = "meshConfig.accessLogFile"
    value = "/dev/stdout"
  }
  set {
    name  = "grafana.enabled"
    value = "true"
  }
  set {
    name  = "kiali.enabled"
    value = "true"
  }
  set {
    name  = "servicegraph.enabled"
    value = "true"
  }
  set {
    name  = "tracing.enabled"
    value = "true"
  }
  depends_on = [helm_release.istio-base]
}

resource "helm_release" "istio-ingress" {
  provider        = helm.cinema
  repository      = local.istio-repo
  name            = "istio-ingressgateway"
  chart           = "gateway"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name
  depends_on      = [helm_release.istiod]
}

resource "helm_release" "istio-egress" {
  provider   = helm.cinema
  repository = local.istio-repo
  name       = "istio-egressgateway"
  chart      = "gateway"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name
  set {
    name  = "service.type"
    value = "ClusterIP"
  }
  depends_on = [helm_release.istiod]
}

resource "helm_release" "bookinfo" {
  provider   = helm.cinema
  repository = local.bookinfo-repo
  name       = "bookinfo"
  chart      = "istio-bookinfo"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.devingress.metadata.0.name
  set {
    name  = "service.type"
    value = "ClusterIP"
  }
  depends_on = [helm_release.istiod]
}
