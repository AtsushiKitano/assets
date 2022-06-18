variable "conf" {
  type = object({
    email        = string
    app_title    = string
    display_name = string
  })
}

/*
Option Config
*/

variable "project" {
  type    = string
  default = null
}
