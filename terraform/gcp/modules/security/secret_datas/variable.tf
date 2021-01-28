variable "secret_datas" {
  type = map(string)
}

variable "key_infos" {
  type = object({
    keyring  = string
    key      = string
    location = string
  })
}

variable "project" {
  type    = string
  default = null
}
