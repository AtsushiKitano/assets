locals {
  services = [ "dns" ]

  _services = [
    for _sv in local.services : _sv if var.dns_api_enable
  ]
}

variable "dns_api_enable" {
  type = bool
  default = true
}

output "_sv" {
  value = local._services
}
