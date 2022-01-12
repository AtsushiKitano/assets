output "subnet_self_link" {
  value = { for v in var.service_subnetworks : v.name => google_compute_subnetwork.main[format("%s/%s", v.region, v.name)].self_link }
}

output "subnet_id" {
  value = { for v in var.service_subnetworks : v.name => google_compute_subnetwork.main[format("%s/%s", v.region, v.name)].id }
}
