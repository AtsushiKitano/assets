variable "gce_instance" {
  type = object({
    name         = string
    machine_type = string
    zone         = string
    subnetwork   = string
    tags         = list(string)
  })
}

variable "boot_disk" {
  type = object({
    name      = string
    size      = number
    interface = string
    image     = string
  })
}

/*
Option Configuration
*/

variable "private_ip" {
  type    = string
  default = null
}

variable "service_account" {
  type    = string
  default = null
}

variable "scopes" {
  type    = list(string)
  default = ["cloud-platform"]
}

variable "scheduling" {
  type    = bool
  default = false
}

variable "preemptible" {
  type    = bool
  default = null
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
    name      = string
    mode      = string
    size      = number
    interface = string
  }))
  default = []
}

variable "project" {
  type    = string
  default = null
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
