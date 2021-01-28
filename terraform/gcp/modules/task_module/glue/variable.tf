variable "conf" {
  type = object({
    name                  = string
    runtime               = string
    region                = string
    environment_variables = map(string)
    opt_var               = map(string)

    pubsub = object({
      name     = string
      opt_conf = map(string)
    })

    gcs = object({
      name     = string
      location = string
      opt_conf = map(string)
    })
  })
}
