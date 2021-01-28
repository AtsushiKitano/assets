variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "project" {
  type    = string
  default = null
}

variable "url_map" {
  type = object({

  })
}


/*
Urlmap Option Configuration
*/

variable "host_rule" {
  type = object({

  })
  default = null
}
