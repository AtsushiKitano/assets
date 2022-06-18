output "router_name" {
  value = google_compute_router.main.name
}

output "router_self_link" {
  value = google_compute_router.main.self_link
}

output "nat_addresses" {
  value = google_compute_address.main.*.address
}
