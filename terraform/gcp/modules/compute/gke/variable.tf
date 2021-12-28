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
    machine_type    = string
    service_account = string
    preemptbile     = bool
    autoscaling = object({
      min_node_count = number
      max_node_count = number
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
  type = list(object({
    resource_type = string
    minimum       = string
    maximum       = string
  }))
  default = []
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

variable "master_authorized_networks_config_cidrs" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "issue_client_certificate" {
  type    = bool
  default = false
}

variable "cluster_autoscalings" {
  type = list(object({
    resource_type = string
    minimum       = number
    maximum       = number
  }))
  default = []
}
