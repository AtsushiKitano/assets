locals {
  gce_conf = yamldecode(file("./data.yaml"))
}

output "file" {
  value = local.gce_conf
}
