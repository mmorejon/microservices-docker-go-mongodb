terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = "1037290380438"
  region  = "us-central1"
  zone    = "us-central1-c"
}
