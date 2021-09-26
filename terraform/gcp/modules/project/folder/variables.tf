#################################################
#################################################
#################################################
variable "root_folders_name" {
  type = list(string)
}

variable "org_id" {
  type = string
}


#################################################
#################################################
#################################################
variable "child_folders" {
  type = list(object({
    name             = string
    root_folder_name = string
  }))
  default = []
}

variable "gland_child_folders" {
  type = list(object({
    name               = string
    parent_folder_name = string
  }))
  default = []
}

variable "gland_glandson_folders" {
  type = list(object({
    name               = string
    parent_folder_name = string
  }))
  default = []
}
