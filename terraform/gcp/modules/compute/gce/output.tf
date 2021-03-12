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

output "static_ip" {
  value = {
    for v in local._external_ip : v => google_compute_address.main[v].address
  }
}

output "gce" {
  value = google_compute_instance.main
}

output "boot_disk" {
  value = google_compute_disk.boot_disk
}

output "attached_disk" {
  value = {
    for v in var.attached_disk : v.name => google_compute_disk.attached_disk
  }
}

output "address" {
  value = {
    for v in local._external_ip : v => google_compute_address.main[v]
  }
}
