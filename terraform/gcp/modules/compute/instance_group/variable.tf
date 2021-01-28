variable "single_zone" {
  type    = bool
  default = false
}

variable "group_manager" {
  type = object({
    base_name    = string
    name         = string
    target_size  = number
    target_pools = list(string)
    version = object({
      name = string
      target_size = object({
        fixed   = number
        percent = number
      })
    })
  })
}

variable "instance_template" {
  type = object({
    name           = string
    disk           = string
    machine_type   = string
    can_ip_forward = bool
    tags           = list(string)
    subnetwork     = string
    disk = object({
      source_image = string
      interface    = string
      mode         = string
      type         = string
      size         = number
    })
  })
}

variable "auto_scaling_policy" {
  type = object({
    name            = string
    min_replicas    = number
    max_replicas    = number
    cooldown_period = number
    mode            = string
  })
}

variable "zone" {
  type    = string
  default = "asia-northeast1-b"
}

variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "project" {
  type    = string
  default = null
}

/*
Instance Template Option Config
*/
variable "accelerator" {
  type = object({
    type  = string
    count = number
  })
  default = null
}

variable "service_account" {
  type    = string
  default = null
}

variable "shielded_instance" {
  type = object({
    enable_secure_boot          = bool
    enable_vtpm                 = bool
    enable_integrity_monitoring = bool
  })
  default = null
}

variable "scheduling" {
  type = object({
    automatic_restart   = bool
    on_host_maintenance = string
    preemptible         = bool
  })
  default = null
}

variable "node_affinities" {
  type = object({
    key            = string
    operator       = string
    affinity_value = string
  })
  default = null
}

variable "encryption_key" {
  type    = string
  default = null
}

variable "alias_ip_range" {
  type = object({
    ip_cidr_range         = string
    subnetwork_range_name = string
  })
  default = null
}

variable "subnetwork_project" {
  type    = string
  default = null
}

variable "scopes" {
  type    = list(string)
  default = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "startup_script" {
  type    = string
  default = null
}

variable "metadata" {
  type    = map(string)
  default = null
}

variable "enable_display" {
  type    = bool
  default = false
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
  default = "pd-standard"
}

variable "auto_delete" {
  type    = bool
  default = true
}

variable "network" {
  type    = string
  default = null
}

variable "network_ip" {
  type    = string
  default = null
}

variable "access_config" {
  type = object({
    nat_ip       = string
    network_tier = string
  })
  default = null
}

variable "template_source" {
  type    = string
  default = null
}

variable "boot" {
  type    = string
  default = null
}

/*
Managed Instance Group Option Config
*/
variable "wait_for_instances" {
  type    = bool
  default = null
}

variable "distribution_policy_zones" {
  type    = list(string)
  default = []
}

variable "update_policy" {
  type = object({
    minimal_action               = string
    type                         = string
    instance_redistribution_type = string
    max_surge_fixed              = number
    max_surge_percent            = number
    max_unavailable_fixed        = number
    max_unavailable_percent      = number
    min_ready_sec                = number
  })
  default = null
}

variable "named_port" {
  type = object({
    name = string
    port = number
  })
  default = null
}

variable "auto_healing_policies" {
  type = object({
    health_check      = string
    initial_delay_sec = number
  })
  default = null
}

variable "stateful_disk" {
  type = object({
    device_name = string
    delete_rule = string
  })
  default = null
}


/*
AutoScaling Option Config
*/

variable "metric" {
  type = object({
    name                       = string
    single_instance_assignment = string
    target                     = string
    type                       = string
    filter                     = string
  })
  default = null
}

variable "load_balancing_utilization" {
  type = object({
    target = string
  })
  default = null
}

variable "cpu_utilization" {
  type = object({
    target = number
  })
  default = null
}

variable "scale_down_control" {
  type = object({
    max_scaled_down = object({
      fixed   = number
      percent = number
    })
    time_window_sec = number
  })
  default = null
}

variable "scale_in_control" {
  type = object({
    max_scaled_in = object({
      fixed   = number
      percent = number
    })
    time_window_sec = number
  })
  default = null
}
