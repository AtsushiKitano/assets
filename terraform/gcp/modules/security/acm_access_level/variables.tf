variable "parent" {
  type = string
}

variable "title" {
  type = string
}

variable "name" {
  type    = string
  default = null
}

variable "conditions" {
  type = list(object({
    type       = string
    conditions = list(string)
  }))
}
