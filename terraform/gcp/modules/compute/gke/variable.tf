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
    disk_size_gb    = number
    disk_type       = string
    metadata        = map(string)
    preemptible     = bool
    tags            = list(string)
    autoscaling = object({
      min_node_count = number
      max_node_count = number
    })
  }))
}

variable "private_cluster_config" {
  type = object({
    enable_private_nodes    = bool
    enable_private_endpoint = bool
    master_ipv4_cidr_block  = string
  })

  default = null
}

/*
  Option Configs
*/
variable "cluster_autoscalings" {
  type = list(object({
    resource_type = string
    minimum       = number
    maximum       = number
  }))
  default = []
}

variable "network" {
  type    = string
  default = null
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

variable "enable_autopilot" {
  type    = bool
  default = null
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

variable "node_count" {
  type    = number
  default = null
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

variable "horizontal_pod_autoscaling" {
  type    = bool
  default = false
}

variable "enable_shielded_nodes" {
  type    = bool
  default = true
}

variable "enable_kubernetes_alpha" {
  type    = bool
  default = false
}

variable "enable_tpu" {
  type    = bool
  default = false
}

variable "enable_binary_authorization" {
  type    = bool
  default = false
}

variable "default_max_pods_per_node" {
  type    = number
  default = null
}

variable "description" {
  type    = string
  default = null
}

variable "enable_components" {
  type    = string
  default = null
}

variable "logging_service" {
  type    = string
  default = "logging.googleapis.com/kubernetes"
}

variable "enable_maintenance_policy" {
  type    = bool
  default = true
}

variable "daily_maintenance_window" {
  type = object({
    start_time = string
  })
  default = { start_time = "00:00" }
}

variable "recurring_window" {
  type = object({
    start_time = string
    end_time   = string
    recurrence = string
  })
  default = null
}

variable "maintenance_exclusion" {
  type = list(object({
    exclusion_name = string
    start_time     = string
    end_time       = string
  }))
  default = []
}

variable "workload_identity_config" {
  type = list(object({
    service_account     = string
    namespace           = string
    k8s_service_account = string
  }))
  default = []
}

variable "dns_config" {
  type = object({
    cluster_dns        = string
    cluster_dns_scope  = string
    cluster_dns_domain = string
  })
  default = null
}

variable "cluster_ipv4_cidr_block" {
  type    = string
  default = null
}

variable "services_ipv4_cidr_block" {
  type    = string
  default = null
}

variable "google_workspace_domain" {
  type    = string
  default = null
}

variable "enabled_multi_cluster" {
  type    = bool
  default = false
}

variable "fleet_host_project" {
  type    = string
  default = null
}

variable "workload_identity_sa_roles" {
  type = list(string)
  default = [
    "roles/compute.networkViewer"
  ]
}
