locals {
  health_check_sample_enable = false

  _health_check_sample = local.health_check_sample_enable ? ["enable"] : []
}

module "health_check_sample" {
  for_each = toset(local._health_check_sample)
  source   = "../modules/compute/health_check"

  global = false

  health_check = {
    name                = "sample"
    check_interval_sec  = 5
    timeout_sec         = 5
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }

  http_health_check = {
    request_path = "/healthz"
    port         = "8080"

    host               = null
    response           = null
    port_name          = null
    proxy_header       = null
    port_specification = null
  }
}

output "health_check_sample" {
  value = module.health_check_sample
}
