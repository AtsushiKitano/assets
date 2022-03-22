locals {
  file_path = "../configs"

  configs = yamldecode(file(format("%s/%s", local.file_path, "config.yaml")))
}
