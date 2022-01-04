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

variable "projects" {
  type    = list(string)
  default = []
}
