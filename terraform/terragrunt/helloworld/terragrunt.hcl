remote_state {
  backend = "gcs"

  config = {
    bucket = "ca-kitano-study-sandbox-state"
    prefix = "terragrunt/${path_relative_to_include()}"
  }
}
