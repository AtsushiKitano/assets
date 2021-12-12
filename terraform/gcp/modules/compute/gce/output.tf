output "instance_id" {
  value = google_compute_instance.main[var.gce_instance.name].instance_id
}

output "id" {
  value = google_compute_instance.main[var.gce_instance.name].id
}

output "self_link" {
  value = google_compute_instance.main[var.gce_instance.name].self_link
}

output "cpu_platform" {
  value = google_compute_instance.main[var.gce_instance.name].cpu_platform
}

output "network_ip" {
  value = google_compute_instance.main[var.gce_instance.name].network_interface.0.network_ip
}

output "nat_ip" {
  value = google_compute_instance.main[var.gce_instance.name].network_interface.0.access_config.0.nat_ip
}

output "boot_disk_self_link" {
  value = google_compute_disk.boot_disk[var.boot_disk.name].self_link
}

output "boot_disk_source_image_id" {
  value = google_compute_disk.boot_disk[var.boot_disk.name].source_image_id
}

output "boot_disk_users" {
  value = google_compute_disk.boot_disk[var.boot_disk.name].users
}

output "boot_disk_id" {
  value = google_compute_disk.boot_disk[var.boot_disk.name].id
}

output "static_ip" {
  value = {
    for v in local._external_ip : v => google_compute_address.main[v].address
  }
}

# output "gce" {
#   value = google_compute_instance.main
# }

output "boot_disk" {
  value = google_compute_disk.boot_disk[var.boot_disk.name]
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
