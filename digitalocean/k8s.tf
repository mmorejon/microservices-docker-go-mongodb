resource "digitalocean_kubernetes_cluster" "cinema" {
  name   = "cinema"
  region = "nyc3"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.24.4-do.0"

  node_pool {
    name       = "core"
    size       = "s-4vcpu-8gb"
    auto_scale = true
    min_nodes  = 2
    max_nodes  = 4
  }
  vpc_uuid = digitalocean_vpc.cinema.id
}

resource "digitalocean_kubernetes_cluster" "loadtesting" {
  name   = "loadtesting"
  region = "nyc3"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.24.4-do.0"

  node_pool {
    name       = "core"
    size       = "s-4vcpu-8gb"
    auto_scale = true
    min_nodes  = 4
    max_nodes  = 4
  }
  vpc_uuid = digitalocean_vpc.loadtesting.id
}
