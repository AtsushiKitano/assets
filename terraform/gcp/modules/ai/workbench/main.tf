resource "google_notebooks_instance" "main" {
  name                   = var.name
  location               = var.location
  project                = var.project
  machine_type           = var.machine_type
  service_account        = var.service_account
  service_account_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

  install_gpu_driver     = var.gpu_driver
  custom_gpu_driver_path = var.custom_gpu_driver
  boot_disk_type         = var.disk_type
  boot_disk_size_gb      = var.disk_size
  data_disk_type         = var.data_disk_type
  data_disk_size_gb      = var.data_disk_size

  no_remove_data_disk = var.no_remove_data_disk

  disk_encryption = var.disk_encryption
  kms_key         = var.disk_encryption == "CMEK" ? var.kms_key : null

  no_public_ip    = var.no_public_ip
  no_proxy_access = var.no_proxy_access
  network         = var.network
  subnet          = var.subnet
  tags            = var.tags

  metadata = var.metadata


  instance_owners     = var.owners
  post_startup_script = var.startup_script

  dynamic "accelerator_config" {
    for_each = var.accelarator_config != null ? ["enable"] : []

    content {
      type       = var.accelarator_config.type
      core_count = var.accelarator_config.core_count
    }
  }

  dynamic "shielded_instance_config" {
    for_each = var.shielded_instance_config != null ? ["enable"] : []

    content {
      enabled_integrity_monitoring = var.shielded_instance_config.enabled_integrity_monitoring
      enable_secure_boot           = var.shielded_instance_config.enable_secure_boot
      enable_vtpm                  = var.shielded_instance_config.oenable_vtpm
    }
  }

  dynamic "vm_image" {
    for_each = var.vm_image != null ? ["enable"] : []

    content {
      project      = var.vm_image.project
      image_family = var.vm_image.image_family
    }
  }

  dynamic "container_image" {
    for_each = var.container_image != null ? ["enable"] : []

    content {
      repository = var.container_image.repository
      tag        = var.container_inage.tag
    }
  }
}
