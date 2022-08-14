variable "network" {
  type = string
}

variable "service" {
  type = string
}

variable "addresses" {
  type = list(object({
    name    = string
    address = string
  }))
}
