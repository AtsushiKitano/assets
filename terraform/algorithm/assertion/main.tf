variable "test" {
  type = number
  default = 20

  validation {
    condition = var.test <= 20 && var.test > 0
    error_message = "The test number must be over 0 and under 20."
  }
}

output "test" {
  value = var.test
}
