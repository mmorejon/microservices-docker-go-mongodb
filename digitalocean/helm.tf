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
  set_sensitive {
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
    value = "{ingress,service,istio-gateway}"
  }
  set {
    name  = "istio-ingress-gateway"
    value = "istio-system/istio-ingressgateway"
  }
}

resource "helm_release" "external-dns-loadtesting" {
  provider   = helm.loadtesting
  depends_on = [digitalocean_kubernetes_cluster.loadtesting, kubernetes_namespace.external-dns-loadtesting]
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
  set_sensitive {
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
    value = "{ingress,service,istio-gateway}"
  }
  set {
    name  = "istio-ingress-gateway"
    value = "istio-system/istio-ingressgateway"
  }
}

resource "helm_release" "cert-manager" {
  provider   = helm.cinema
  depends_on = [kubernetes_namespace.cert-manager]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.9.1"
  namespace  = "cert-manager"
  timeout    = 120
  set {
    name  = "createCustomResource"
    value = "true"
  }
  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "cert-manager-loadtesting" {
  provider   = helm.loadtesting
  depends_on = [kubernetes_namespace.cert-manager-loadtesting]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.9.1"
  namespace  = "cert-manager"
  timeout    = 120
  set {
    name  = "createCustomResource"
    value = "true"
  }
  set {
    name  = "installCRDs"
    value = "true"
  }
}

/*
resource "helm_release" "kubed" {
  provider   = helm.cinema
  depends_on = [kubernetes_namespace.cert-manager]
  name       = "kubed"
  repository = "https://charts.appscode.com/stable/"
  chart      = "kubed"
  version    = "v0.13.2"
  namespace  = "kube-system"
  timeout    = 120
  set {
    name  = "apiserver.enabled"
    value = "false"
  }
  set {
    name  = "config.clusterName"
    value = "cinema"
  }
}
*/

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

resource "helm_release" "istio-base-loadtesting" {
  provider        = helm.loadtesting
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

resource "helm_release" "istiod-loadtesting" {
  provider        = helm.loadtesting
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
  depends_on = [helm_release.istio-base-loadtesting]
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

resource "helm_release" "istio-ingress-loadtesting" {
  provider        = helm.loadtesting
  repository      = local.istio-repo
  name            = "istio-ingressgateway"
  chart           = "gateway"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name
  depends_on      = [helm_release.istiod-loadtesting]
}

resource "helm_release" "istio-egress" {
  provider        = helm.cinema
  repository      = local.istio-repo
  name            = "istio-egressgateway"
  chart           = "gateway"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name
  set {
    name  = "service.type"
    value = "ClusterIP"
  }
  depends_on = [helm_release.istiod]
}

resource "helm_release" "istio-egress-loadtesting" {
  provider        = helm.loadtesting
  repository      = local.istio-repo
  name            = "istio-egressgateway"
  chart           = "gateway"
  cleanup_on_fail = true
  force_update    = true
  namespace       = kubernetes_namespace.istio-system.metadata.0.name
  set {
    name  = "service.type"
    value = "ClusterIP"
  }
  depends_on = [helm_release.istiod-loadtesting]
}

resource "helm_release" "argocd" {
  depends_on      = [kubernetes_namespace.argocd]
  provider        = helm.cinema
  repository      = local.argocd-repo
  version         = "5.1.0"
  namespace       = "argocd"
  name            = "argocd"
  chart           = "argo-cd"
  cleanup_on_fail = true
  force_update    = true
  values = [
    local.argocd_dex_google,
    local.argocd_dex_rbac
  ]
  set {
    name  = "server.extraArgs"
    value = "{--insecure}"
  }
  /*
  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.argocd_oidc_client_secret
  }
  set {
    name  = "configs.secret.argocdServerAdminPasswordMtime"
    value = timestamp()
  }
 */
}

resource "helm_release" "cluster-issuer" {
  provider  = helm.cinema
  name      = "cluster-issuer"
  chart     = "../charts/cluster-issuer"
  namespace = "kube-system"
  depends_on = [
    digitalocean_kubernetes_cluster.cinema,
  ]
  set_sensitive {
    name  = "zerossl_email"
    value = var.zerossl_email
  }
  set_sensitive {
    name  = "zerossl-eab-hmac-key"
    value = var.zerossl_eab_hmac_key
  }
  set_sensitive {
    name  = "zerossl-eab-hmac-key-id"
    value = var.zerossl_eab_hmac_key_id
  }
}

