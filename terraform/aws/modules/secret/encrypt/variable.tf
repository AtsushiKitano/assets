variable "config" {
  type = object({
    key_id    = string
    plaintext = string
  })
}
