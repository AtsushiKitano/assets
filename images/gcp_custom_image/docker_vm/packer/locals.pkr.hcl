locals {
  gce_img_family = "ubuntu-2004-lts"
  user           = "packer"
  machine_type   = "f1-micro"
  zone           = "asia-northeast1-b"
  subnetwork     = "custom-img"
}
