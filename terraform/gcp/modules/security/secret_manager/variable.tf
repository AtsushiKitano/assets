variable "secret_id" {
  type = string
}

variable "automatic" {
  type    = string
  default = null
}

variable "user_managed" {
  type = object({
    replicas = list(object({
      location = string
    }))
  })
  default = null
}

variable "project" {
  type    = string
  default = null
}
