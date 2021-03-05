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

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    subnetwork_self_link = "module.network.subnetwork_self_link"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  subnet_self_link = dependency.network.outputs.sub
}
