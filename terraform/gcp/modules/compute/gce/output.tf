output "instance_id" {
  value = google_compute_instance.main.instance_id
}

output "id" {
  value = google_compute_instance.main.id
}

output "self_link" {
  value = google_compute_instance.main.self_link
}

output "cpu_platform" {
  value = google_compute_instance.main.cpu_platform
}

output "network_ip" {
  value = google_compute_instance.main.network_interface.0.network_ip
}

output "nat_ip" {
  value = google_compute_instance.main.network_interface.0.access_config.0.nat_ip
}

output "boot_disk_self_link" {
  value = google_compute_disk.boot_disk.self_link
}

output "boot_disk_source_image_id" {
  value = google_compute_disk.boot_disk.source_image_id
}

output "boot_disk_users" {
  value = google_compute_disk.boot_disk.users
}

output "boot_disk_id" {
  value = google_compute_disk.boot_disk.id
}

