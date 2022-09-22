resource "digitalocean_vpc" "cinema" {
  name     = "cinema-network"
  region   = "nyc3"
  ip_range = "10.0.0.0/22" // 2046 max hosts
}


//
