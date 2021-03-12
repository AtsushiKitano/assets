output "self_link" {
  value = google_compute_network.main.self_link
}

output "subnetwork_self_link" {
  value = {
    for v in var.subnetworks : v.name => google_compute_subnetwork.main[v.name].self_link
  }
}

output "serverless_vpc_self_link" {
  value = {
    for v in var.serverless_vpc : v.name => google_vpc_access_connector.main[v.name].self_link
  }
}

output "vpc" {
  value = google_compute_network.main
}

output "subnetwork" {
  value = {
    for v in var.subnetworks : v.name => google_compute_subnetwork.main[v.name]
  }
}

output "firewall" {
  value = {
    for v in var.firewall : v.name => google_compute_firewall.main[v.name]
  }
}
