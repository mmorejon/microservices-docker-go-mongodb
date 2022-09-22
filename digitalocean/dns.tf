resource "digitalocean_domain" "do-wayofthesys" {
  name       = "do.wayofthesys.com"
}

resource "digitalocean_record" "test" {
  domain = digitalocean_domain.do-wayofthesys.id
  type   = "A"
  name   = "www"
  value  = "159.89.244.226"
}

