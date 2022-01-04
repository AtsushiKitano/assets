variable "access_policy" {
  type = number
}

variable "title" {
  type = string
}

variable "name" {
  type    = string
  default = null
}

variable "description" {
  type    = string
  default = null
}

variable "status" {
  type = object({
    projects            = list(string)
    restricted_services = list(string)
    access_levels       = list(string)
  })
}
