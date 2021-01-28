variable "global" {
  type    = bool
  default = true
}

variable "health_check" {
  type = object({
    name                = string
    check_interval_sec  = number
    healthy_threshold   = number
    unhealthy_threshold = number
    timeout_sec         = number
  })
}

/*
HealthCheck Option Config
*/

variable "http_health_check" {
  type = object({
    host               = string
    request_path       = string
    response           = string
    port               = string
    port_name          = string
    proxy_header       = string
    port_specification = string
  })
  default = null
}

variable "https_health_check" {
  type = object({
    host               = string
    request_path       = string
    response           = string
    port               = string
    port_name          = string
    proxy_header       = string
    port_specification = string
  })
  default = null
}

variable "http2_health_check" {
  type = object({
    host               = string
    request_path       = string
    response           = string
    port               = string
    port_name          = string
    proxy_header       = string
    port_specification = string
  })
  default = null
}

variable "tcp_health_check" {
  type = object({
    request            = string
    response           = string
    port               = string
    port_name          = string
    proxy_header       = string
    port_specification = string
  })
  default = null
}

variable "ssl_health_check" {
  type = object({
    request            = string
    response           = string
    port               = string
    port_name          = string
    proxy_header       = string
    port_specification = string
  })
  default = null
}

variable "grpc_health_check" {
  type = object({
    port               = string
    port_name          = string
    port_specification = string
    grpc_service_name  = string
  })
  default = null
}

variable "log_config" {
  type = object({
    enable = bool
  })
  default = null
}

variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "project" {
  type    = string
  default = null
}
