terraform {
  backend "gcs" {
    bucket = "ca-kitano-study-sandbox-terraform-modules-state"
    prefix = "network"
  }
}

provider "google" {
  project = terraform.workspace
}

provider "google-beta" {
  project = terraform.workspace
}
