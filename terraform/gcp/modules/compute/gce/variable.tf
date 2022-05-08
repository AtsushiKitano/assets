variable "name" {
  type = string
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "zone" {
  type    = string
  default = "asia-northeast1-c"
}

variable "subnetwork" {
  type = string
}

variable "size" {
  type    = number
  default = 50
}

variable "image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "project" {
  type = string
}

variable "service_account" {
  type = string
}


/*
Option Configuration
*/
variable "tags" {
  type    = list(string)
  default = []
}


variable "private_ip" {
  type    = string
  default = null
}

variable "scopes" {
  type    = list(string)
  default = ["cloud-platform"]
}

variable "scheduling" {
  type    = bool
  default = true
}

variable "preemptible" {
  type    = bool
  default = true
}

variable "on_host_maintenance" {
  type    = string
  default = "MIGRATE"
}

variable "automatic_restart" {
  type    = bool
  default = true
}

variable "attached_disk" {
  type = list(object({
    name = string
    mode = string
    size = number
  }))
  default = []
}


variable "boot_disk_auto_delete" {
  type    = bool
  default = true
}

variable "boot_disk_device_name" {
  type    = string
  default = null
}

variable "access_config" {
  type    = bool
  default = true
}

variable "nat_ip" {
  type    = string
  default = null
}

variable "public_ptr_domain_name" {
  type    = string
  default = null
}

variable "network_tier" {
  type    = string
  default = "PREMIUM"
}

variable "accelerator" {
  type = object({
    type  = string
    count = number
  })
  default = null
}

variable "startup_script" {
  type    = string
  default = null
}

variable "external_ip" {
  type    = string
  default = null
}

variable "external_ip_type" {
  type    = string
  default = "EXTERNAL"
}

variable "external_ip_purpose" {
  type    = string
  default = null
}

variable "external_ip_network_tier" {
  type    = string
  default = "PREMIUM"
}

variable "external_ip_address" {
  type    = string
  default = null
}

variable "external_ip_subnetwork" {
  type    = string
  default = null
}

variable "external_ip_region" {
  type    = string
  default = null
}

variable "enabled" {
  type    = bool
  default = true
}

variable "allow_stopping_for_update" {
  type    = bool
  default = true
}

variable "metadata" {
  type    = map(string)
  default = null
}
