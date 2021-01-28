source "googlecompute" "nested" {
  project_id          = var.project-id
  source_image_family = local.img_family
  preemptible         = true
  ssh_username        = local.user
  zone                = local.zone
  image_name          = var.img-name
  machine_type        = var.machine_type
  subnetwork          = local.subnetwork

  image_licenses = [
    "projects/vm-options/global/licenses/enable-vmx"
  ]
}
