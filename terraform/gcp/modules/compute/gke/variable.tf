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
  type = string
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

variable "autopilot" {
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
