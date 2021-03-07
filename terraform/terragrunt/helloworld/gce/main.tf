variable "subnet_self_link" {
  type = string
}

module "gce_sample" {
  source = "github.com/AtsushiKitano/assets/terraform/gcp/modules/compute/gce"

  gce_instance = {
    name         = terraform.workspace
    machine_type = "f1-micro"
    zone         = "asia-northeast1-b"
    subnetwork   = var.subnet_self_link
    tags         = []
  }

  boot_disk = {
    name      = terraform.workspace
    size      = 20
    interface = null
    image     = "ubuntu-os-cloud/ubuntu-2004-lts"
  }

  project = "ca-kitano-study-sandbox"
}

