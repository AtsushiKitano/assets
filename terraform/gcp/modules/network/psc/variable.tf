variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "address" {
  type = string
}

variable "target" {
  type    = string
  default = "all-apis"
}

variable "load_balancing_scheme" {
  type    = string
  default = null
}
