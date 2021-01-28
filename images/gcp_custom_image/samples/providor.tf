provider "google" {
  project = terraform.workspace
}

provider "google-beta" {
  project = terraform.workspace
}
