variable "peering" {
  type = object({
    main_name = string
    sub_name  = string
    network   = list(string)
  })
}

variable "export_custom_routes" {
  type    = map(bool)
  default = null
}

variable "import_custom_routes" {
  type    = map(bool)
  default = null
}

variable "export_subnet_routes_with_public_ip" {
  type    = map(bool)
  default = null
}

variable "import_subnet_routes_with_public_ip" {
  type    = map(bool)
  default = null
}
