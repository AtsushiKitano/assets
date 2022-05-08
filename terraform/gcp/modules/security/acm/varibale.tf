variable "parent" {
  type = string
}

variable "title" {
  type = string
}

variable "conditions" {
  type = list(object({
    ip_addresses     = list(string)
    service_accounts = list(string)
    users            = list(string)
    regions          = list(string)
  }))
}
