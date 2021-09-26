variable "email" {
  type = string
}

variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "members" {
  type = list(object({
    email = string
    role  = string
  }))
  default = []
}

variable "timeouts" {
  type = object({
    create = string
    update = string
  })
  default = null
}

variable "aliases" {
  type    = list(string)
  default = []
}
