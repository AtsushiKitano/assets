include {
  path = find_in_parent_folders()
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
