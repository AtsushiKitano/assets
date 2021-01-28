source "googlecompute" "docker-vm" {
  project_id          = var.pj_id
  source_image_family = local.gce_img_family
  preemptible         = true
  ssh_username        = local.user
  zone                = local.zone
  image_name          = var.img_name
  machine_type        = local.machine_type
  subnetwork          = local.subnetwork
}
