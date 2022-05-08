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


output "boot_disk_self_link" {
  value = google_compute_disk.boot_disk.self_link
}

