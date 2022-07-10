variable "name" {
  type = string
}

variable "project" {
  type = string
}

variable "network" {
  type = string
}

variable "address" {
  type = string
}

variable "enable_api_type" {
  type    = string
  default = "all-apis"

  validation {
    condition     = var.enable_api_type == "all-apis" || var.enable_api_type == "vpc-sc"
    error_message = "the enable_api_type must be all-apis or vpc-sc."
  }
}

variable "lb_scheme" {
  type    = string
  default = ""
}

variable "dnses" {
  type = list(object({
    name     = string
    dns_name = string
    record_sets = list(object({
      name    = string
      rrdatas = list(string)
      ttl     = number
      type    = string
    }))
  }))
}
