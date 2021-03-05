remote_state {
  backend = "gcs"

  config = {
    bucket = "ca-kitano-study-sandbox-state"
    prefix = "terragrunt/${path_relative_to_include()}/${get_env("ENV")}"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "google" {
  project = "ca-kitano-study-sandbox"
}
EOF
}

generate "backend" {
  path = "terraform.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "gcs" {}
}
EOF
}
