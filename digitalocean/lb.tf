/* 
resource "digitalocean_loadbalancer" "ingress_load_balancer" {
  name   = "${var.domain_name[0]}-lb"
  region = var.do_region
  size = "lb-medium"
  algorithm = "round_robin"

  forwarding_rule {
    entry_port     = 80 
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"

  }

  lifecycle {
      ignore_changes = [
        forwarding_rule,
    ]
  }

  vpc_uuid = digitalocean_vpc.cinema.id 
  droplet_ids = digitalocean_kubernetes_cluster.cinema.node_pool[0].nodes[*].droplet_id
}
*/
