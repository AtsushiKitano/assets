variable "secret_id" {
  type = string
}

variable "locations" {
  type = list(string)
}

variable "project" {
  type    = string
  default = null
}
