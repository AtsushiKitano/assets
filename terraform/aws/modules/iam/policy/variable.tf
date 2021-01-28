variable "config" {
  type = object({
    name   = string
    group  = string
    policy = string
  })
}
