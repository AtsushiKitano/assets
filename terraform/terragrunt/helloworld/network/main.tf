module "network" {
  source = "github.com/AtsushiKitano/assets/terraform/gcp/modules/network/vpc_network"

  project = "ca-kitano-study-sandbox"

  vpc_network = {
    name = "sample"
  }
  subnetworks = [
    {
      name   = "sample"
      cidr   = "192.168.10.0/24"
      region = "asia-northeast1"
    }
  ]

  firewall = [
  ]
}

output "sub" {
  value = module.network.subnetwork_self_link["sample"]
}
