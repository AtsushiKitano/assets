output "serverless_vpc_self_link" {
  value = {
    for v in var.serverless_vpc : v.name => google_vpc_access_connector.main[v.name].self_link
  }
}

output "serverless_vpc_name" {
  value = {
    for v in var.serverless_vpc : v.name => google_vpc_access_connector.main[v.name].name
  }
}

output "serverless_vpc_id" {
  value = {
    for v in var.serverless_vpc : v.name => google_vpc_access_connector.main[v.name].id
  }
}

output "subnetwork_self_link" {
  value = {
    for v in var.subnetworks : v.name => google_compute_subnetwork.main[v.name].self_link
  }
}

output "subnetwork_id" {
  value = {
    for v in var.subnetworks : v.name => google_compute_subnetwork.main[v.name].id
  }
}

output "subnetwork_gateway_address" {
  value = {
    for v in var.subnetworks : v.name => google_compute_subnetwork.main[v.name].gateway_address
  }
}

output "subnetwork_name" {
  value = [
    for v in var.subnetworks : v.name
  ]
}

output "self_link" {
  value = google_compute_network.main.self_link
}

output "id" {
  value = google_compute_network.main.id
}

output "gateway_ipv4" {
  value = google_compute_network.main.gateway_ipv4
}

output "name" {
  value = google_compute_network.main.name
}

output "firewall" {
  value = google_compute_firewall.main
}
