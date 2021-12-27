variable "cluster_name" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "cluster_ipv4_cidr" {
  type    = string
  default = null
}

variable "node_pools" {
  type = list(object({
    name            = string
    disk_size_gb    = number
    disk_type       = string
    image_type      = string
    machine_type    = string
    service_account = string
    tags            = list(string)
    autoscaling = object({
      min_node_count = number
      max_node_count = number
    })
    management = object({
      auto_repair  = bool
      auto_upgrade = bool
    })
    upgrade_settings = object({
      max_surge       = number
      max_unavailable = number
    })
  }))
}

variable "private_cluster_config" {
  type = object({
    enable_private_nodes                = bool
    enable_private_endpoint             = bool
    master_ipv4_cidr_block              = string
    master_global_access_config_enabled = bool
  })

  default = null
}

/*
  Option Configs
*/
variable "cluster_autoscaling" {
  type = object({
    resource_type = string
    minimum       = string
    maximum       = string
  })
  default = null
}

variable "logging_service" {
  type    = string
  default = null
}

variable "network" {
  type    = string
  default = null
}

variable "enable_components" {
  type    = string
  default = null
}

variable "default_max_pods_per_node" {
  type    = number
  default = null
}

variable "enable_binary_authorization" {
  type    = bool
  default = false
}

variable "enable_tpu" {
  type    = bool
  default = false
}

variable "networking_mode" {
  type    = string
  default = "VPC_NATIVE"
}

variable "remove_default_node_pool" {
  type    = bool
  default = true
}

variable "node_locations" {
  type    = list(string)
  default = []
}

variable "oauth_scopes" {
  type    = map(string)
  default = {}
}

variable "preemptible_nodes" {
  type    = list(string)
  default = []
}

variable "enable_autopilot" {
  type    = bool
  default = false
}

variable "enable_binary_authorizajtion" {
  type    = bool
  default = false
}

variable "cluster_secondary_range_name" {
  type    = string
  default = null
}

variable "services_secondary_range_name" {
  type    = string
  default = null
}

variable "initial_node_count" {
  type    = number
  default = 1
}

variable "timeouts" {
  type = object({
    create = string
    update = string
  })
  default = {
    create = "30m"
    update = "40m"
  }
}

variable "master_authorized_networks_config" {
  type = object({
    cidr_block = string
    # cidr_blocks = list(object({
    #   cidr_block   = string
    #   display_name = string
    # }))
  })
  default = null
}

variable "issue_client_certificate" {
  type    = bool
  default = false
}
