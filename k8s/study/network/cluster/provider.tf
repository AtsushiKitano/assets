provider "google" {
  version = "3.8.0"
  project = terraform.workspace
  region  = "asia-northeast1"
  zone    = "asia-northeast1-b"
}

provider "google-beta" {
  version = "3.8.0"
  project = terraform.workspace
  region  = "asia-northeast1"
  zone    = "asia-northeast1-b"
}
