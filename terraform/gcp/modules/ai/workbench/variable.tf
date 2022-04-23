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

variable "subnetwork" {
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

  validation {
    condition     = var.disk_type == "DISK_TYPE_UNSPECIFIED" || var.disk_type == "PD_STANDARD" || var.disk_type == "PD_SSD" || var.disk_type == "PD_BALANCED"
    error_message = "disk_type must be DISK_TYPE_UNSPECIFIED, PD_STANDARD, PD_SSD or PD_BALANCED"
  }
}

variable "disk_size" {
  type    = number
  default = 100

  validation {
    condition     = var.disk_size >= 100 && var.disk_size < 64000
    error_message = "disk_size must be larger than 100 and smaller than 64000"
  }
}

variable "data_disk_type" {
  type    = string
  default = null

  validation {
    condition     = var.data_disk_type == "DISK_TYPE_UNSPECIFIED" || var.data_disk_type == "PD_STANDARD" || var.data_disk_type == "PD_SSD" || var.data_disk_type == "PD_BALANCED" || var.data_disk_type == null
    error_message = "data_disk_type must be DISK_TYPE_UNSPECIFIED, PD_STANDARD, PD_SSD or PD_BALANCED"
  }
}

variable "data_disk_size" {
  type    = number
  default = null

  validation {
    condition     = var.disk_size < 64000 || var.disk_size == null
    error_message = "disk_size must be smaller than 64000"
  }
}

variable "no_remove_data_disk" {
  type    = bool
  default = false
}

variable "disk_encryption" {
  type    = string
  default = null

  validation {
    condition     = var.disk_encryption == "CMEK" || var.disk_encryption == "GMEK" || var.disk_encryption == "DISK_ENCRYPTION_UNSPECIFIED"
    error_message = "disk_encryption must be CMEK, GMEK or DISK_ENCRYPTION_UNSPECIFIED"
  }
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

variable "shilded_instance_config" {
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

variable "reservation_affinity" {
  type = object({
    consume_reservation_type = string
    key                      = string
    value                    = map(string)
  })
  default = null
}

variable "vm_image" {
  type = object({
    project      = string
    image_family = string
  })
  default = null
}

variable "container_inage" {
  type = object({
    repository = string
    tag        = string
  })
  default = null
}
