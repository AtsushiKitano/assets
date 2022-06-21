output "region_mig_instance_group" {
  value = var.multi_region_enabled ? google_compute_region_instance_group_manager.main[var.name].instance_group : null
}

output "mig_instance_group" {
  value = !var.multi_region_enabled ? google_compute_instance_group_manager.main[var.name].instance_group : null
}
