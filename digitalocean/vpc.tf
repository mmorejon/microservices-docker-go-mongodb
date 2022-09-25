resource "digitalocean_vpc" "cinema" {
  name     = "cinema-prod"
  region   = "nyc3"
  ip_range = "10.1.0.0/22" // 2046 max hosts
}


