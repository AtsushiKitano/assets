locals {
  _file_type = var.file_type == "csv" ? "CSV-file" : var.file_type == "yaml" ? "YAML-file" : "JSON-file"
}

variable "file_type" {
  type = string
  default = "json"
}

output "file_type" {
  value = local._file_type
}
