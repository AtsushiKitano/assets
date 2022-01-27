output "instance_id" {
  value = var.enabled ? google_compute_instance.main[var.gce_instance.name].instance_id : null
}

output "id" {
  value = var.enabled ? google_compute_instance.main[var.gce_instance.name].id : null
}

output "self_link" {
  value = var.enabled ? google_compute_instance.main[var.gce_instance.name].self_link : null
}

output "cpu_platform" {
  value = var.enabled ? google_compute_instance.main[var.gce_instance.name].cpu_platform : null
}

output "network_ip" {
  value = var.enabled && var.access_config ? google_compute_instance.main[var.gce_instance.name].network_interface.0.network_ip : null
}

output "nat_ip" {
  value = var.enabled ? google_compute_instance.main[var.gce_instance.name].network_interface.0.access_config.0.nat_ip : null
}

output "boot_disk_self_link" {
  value = var.enabled ? google_compute_disk.boot_disk[var.boot_disk.name].self_link : null
}

output "boot_disk_source_image_id" {
  value = var.enabled ? google_compute_disk.boot_disk[var.boot_disk.name].source_image_id : null
}

output "boot_disk_users" {
  value = var.enabled ? google_compute_disk.boot_disk[var.boot_disk.name].users : null
}

output "boot_disk_id" {
  value = var.enabled ? google_compute_disk.boot_disk[var.boot_disk.name].id : null
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
  value = var.enabled ? google_compute_disk.boot_disk[var.boot_disk.name] : null
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
