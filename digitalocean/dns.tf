resource "digitalocean_domain" "do-wayofthesys" {
  name       = "do.wayofthesys.com"
}

resource "digitalocean_domain" "cinema-do-wayofthesys" {
  name       = "test.do.wayofthesys.com"
  ip_address = "159.89.244.226"
}
