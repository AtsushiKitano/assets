source "googlecompute" "nginx" {
  project_id          = local.configs.project_id
  source_image_family = local.configs.image_family
  network             = "research"
  subnetwork          = "research"
  preemptible         = true
  ssh_username        = "packer"
  zone                = "asia-northeast1-b"
  image_name          = local.configs.image_name
}
