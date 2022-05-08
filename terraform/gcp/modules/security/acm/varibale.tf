variable "parent" {
  type = string
}

variable "title" {
  type = string
}

variable "combining_function" {
  type    = string
  default = "AND"
}

variable "ip_addresses" {
  type    = list(string)
  default = []
}

variable "users" {
  type    = list(string)
  default = []
}

variable "service_accounts" {
  type    = list(string)
  default = []
}

variable "regions" {
  type    = list(string)
  default = []
}

variable "additional_conditions" {
  type = list(object({
    ip_addresses     = list(string)
    service_accounts = list(string)
    users            = list(string)
    regions          = list(string)
  }))
  default = []
}
