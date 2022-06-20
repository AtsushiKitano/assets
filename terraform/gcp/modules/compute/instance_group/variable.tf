/*
  Required Values
*/
variable "version_name" {
  type = string
}

variable "source_image" {
  type = string
}

variable "service_account" {
  type = string
}

variable "base_instance_name" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type = string
}

variable "machine_type" {
  type = string
}


/*
  Option Values
*/
variable "zone" {
  type    = string
  default = null
}

variable "auto_delete" {
  type    = bool
  default = true
}

variable "device_name" {
  type    = string
  default = null
}

variable "disk_name" {
  type    = string
  default = null
}

variable "disk_type" {
  type    = string
  default = "pd-ssd"

  validation {
    condition     = var.disk_type == "pd-ssd" || var.disk_type == "local-ssd" || var.disk_type == "pd-balanced" || var.disk_type == "pd-standard"
    error_message = "The disk_type must be pd-ssd, local-ssd, pd-balanced or pd-standard."
  }
}

variable "disk_size" {
  type    = number
  default = null
}

variable "disk_interface" {
  type    = string
  default = null

  validation {
    condition     = var.disk_interface == "NVME" || var.disk_interface == "SCSI" || var.disk_interface == null
    error_message = "The disk_interface must be NVME or SCSI"
  }
}

variable "disk_mode" {
  type    = string
  default = "READ_WRITE"

  validation {
    condition     = var.disk_mode == "READ_WRITE" || var.disk_mode == "READ_ONLY"
    error_message = "The disk_mode must be READ_WRITE or READ_ONLY."
  }
}

variable "encryption_key" {
  type    = string
  default = null
}

variable "scheduling_elabled" {
  type    = bool
  default = true
}

variable "automatic_restart" {
  type    = bool
  default = false
}

variable "on_host_maintenance" {
  type    = string
  default = "TERMINATE"

  validation {
    condition     = var.on_host_maintenance == "TERMINATE" || var.on_host_maintenance == "MIGRATE"
    error_message = "The on_host_maintenance must be TERMINATE or MIGRATE."
  }
}

variable "preemptible" {
  type    = bool
  default = true
}

variable "scopes" {
  type    = list(string)
  default = ["cloud-platform"]
}

variable "accelerator" {
  type = object({
    type  = string
    count = number
  })
  default = null
}

variable "shielded_instance_enabled" {
  type    = bool
  default = true
}

variable "secure_boot_enabled" {
  type    = bool
  default = true
}

variable "vtpm_enabled" {
  type    = bool
  default = true
}

variable "integrity_monitoring_enabled" {
  type    = bool
  default = true
}

variable "subnetwork_project" {
  type    = string
  default = null
}

variable "network_ip" {
  type    = string
  default = null
}

variable "can_ip_forward" {
  type    = bool
  default = false
}

variable "startup_script" {
  type    = string
  default = null
}

variable "metadata" {
  type    = map(string)
  default = null
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "multi_region_enabled" {
  type    = bool
  default = true
}

variable "target_pools" {
  type    = list(string)
  default = []
}

variable "target_size" {
  type    = number
  default = null
}

variable "wait_for_instances" {
  type    = string
  default = null

  validation {
    condition     = var.wait_for_instances == "STABLE" || var.wait_for_instances == "UPDATE" || var.wait_for_instances == null
    error_message = "The wait_for_instances must be STABLE or UPDATE."
  }
}

variable "auto_healing_elebled" {
  type    = bool
  default = true
}

variable "timeout_sec" {
  type    = number
  default = 1
}

variable "check_interval_sec" {
  type    = number
  default = 1
}

variable "target_size_enabled" {
  type    = bool
  default = false
}

variable "fixed_size" {
  type    = number
  default = null
}

variable "percent" {
  type    = number
  default = null
}

variable "stateful_disk_enabled" {
  type    = bool
  default = false
}

variable "delete_rule" {
  type    = string
  default = "NEVER"

  validation {
    condition     = var.delete_rule == "NEVER" || var.delete_rule == "ON_PERMANENT_INSTANCE_DELETION"
    error_message = "The delete_rule must be NEVER or ON__PERMANENT_INSTANCE_DELETION."
  }
}

variable "port" {
  type    = string
  default = "22"
}
