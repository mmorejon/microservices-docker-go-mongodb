resource "digitalocean_vpc" "cinema" {
  name     = "cinema-prod"
  region   = "nyc3"
  ip_range = "10.1.0.0/22" // 2046 max hosts
}

resource "digitalocean_vpc" "loadtesting" {
  name     = "loadtesting-prod"
  region   = "nyc3"
  ip_range = "10.2.0.0/22" // 2046 max hosts
}


