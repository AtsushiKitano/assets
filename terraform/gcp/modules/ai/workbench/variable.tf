variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "project" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "service_account" {
  type = string
}

variable "network" {
  type = string
}

variable "subnet" {
  type = string
}


/*
   Config Values
*/
variable "tags" {
  type    = list(string)
  default = []
}

variable "metadata" {
  type    = map(string)
  default = null
}

variable "gpu_driver" {
  type    = bool
  default = false
}

variable "custom_gpu_driver" {
  type    = string
  default = null
}

variable "disk_type" {
  type    = string
  default = "PD_BALANCED"
}

variable "disk_size" {
  type    = number
  default = 100
}

variable "data_disk_type" {
  type    = string
  default = null
}

variable "data_disk_size" {
  type    = number
  default = null
}

variable "no_remove_data_disk" {
  type    = bool
  default = false
}

variable "disk_encryption" {
  type    = string
  default = null
}

variable "kms_key" {
  type    = string
  default = null
}

variable "no_public_ip" {
  type    = bool
  default = false
}

variable "no_proxy_access" {
  type    = bool
  default = false
}

variable "accelarator_config" {
  type = object({
    type       = string
    core_count = number
  })
  default = null
}

variable "shielded_instance_config" {
  type = object({
    enable_integrity_monitoring = bool
    enable_secure_boot          = bool
    enable_vtpm                 = bool
  })
  default = {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }
}

variable "vm_image" {
  type = object({
    project      = string
    image_family = string
  })
  default = null
}

variable "container_image" {
  type = object({
    repository = string
    tag        = string
  })
  default = null
}

variable "startup_script" {
  type    = string
  default = null
}

variable "owners" {
  type    = list(string)
  default = []
}
