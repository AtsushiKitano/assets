variable "dataset" {
  type = object({
    dataset_id                  = string
    location                    = string
    default_table_expiration_ms = number
  })
}

variable "table" {
  type = list(object({
    name = string
  }))
  default = []
}

variable "project" {
  type    = string
  default = null
}

variable "default_partition_expiration_ms" {
  type    = number
  default = null
}

variable "friendly_name" {
  type    = string
  default = null
}

variable "delete_contents_on_destroy" {
  type    = bool
  default = true
}

variable "access" {
  type = list(object({
    domain         = string
    group_by_email = string
    role           = string
    special_group  = string
    user_by_email  = string

    view = object({
      dataset_id = string
      project_id = string
      table_id   = string
    })
  }))
  default = []
}
