locals {
  global_hc   = var.global ? [var.health_check] : []
  regional_hc = ! var.global ? [var.health_check] : []
}

resource "google_compute_health_check" "main" {
  provider = google-beta
  for_each = { for v in local.global_hc : v.name => v }

  name    = each.value.name
  project = var.project

  check_interval_sec  = each.value.check_interval_sec
  healthy_threshold   = each.value.healthy_threshold
  unhealthy_threshold = each.value.unhealthy_threshold
  timeout_sec         = each.value.timeout_sec

  dynamic "http_health_check" {
    for_each = var.http_health_check != null ? [var.http_health_check] : []
    iterator = _conf

    content {
      host               = _conf.value.host
      request_path       = _conf.value.request_path
      response           = _conf.value.response
      port               = _conf.value.port
      port_name          = _conf.value.port_name
      proxy_header       = _conf.value.proxy_header
      port_specification = _conf.value.port_specification
    }
  }

  dynamic "https_health_check" {
    for_each = var.https_health_check != null ? [var.https_health_check] : []
    iterator = _conf

    content {
      host               = _conf.value.host
      request_path       = _conf.value.request_path
      response           = _conf.value.response
      port               = _conf.value.port
      port_name          = _conf.value.port_name
      proxy_header       = _conf.value.proxy_header
      port_specification = _conf.value.port_specification
    }
  }

  dynamic "tcp_health_check" {
    for_each = var.tcp_health_check != null ? [var.tcp_health_check] : []
    iterator = _conf

    content {
      request            = _conf.value.request
      response           = _conf.value.response
      port               = _conf.value.port
      port_name          = _conf.value.port_name
      proxy_header       = _conf.value.proxy_header
      port_specification = _conf.value.port_specification
    }
  }

  dynamic "ssl_health_check" {
    for_each = var.ssl_health_check != null ? [var.ssl_health_check] : []
    iterator = _conf

    content {
      request            = _conf.value.request
      response           = _conf.value.response
      port               = _conf.value.port
      port_name          = _conf.value.port_name
      proxy_header       = _conf.value.proxy_header
      port_specification = _conf.value.port_specification
    }
  }

  dynamic "http2_health_check" {
    for_each = var.http2_health_check != null ? [var.http2_health_check] : []
    iterator = _conf

    content {
      host               = _conf.value.host
      request_path       = _conf.value.request_path
      response           = _conf.value.response
      port               = _conf.value.port
      port_name          = _conf.value.port_name
      proxy_header       = _conf.value.proxy_header
      port_specification = _conf.value.port_specification
    }
  }

  dynamic "grpc_health_check" {
    for_each = var.grpc_health_check != null ? [var.grpc_health_check] : []
    iterator = _conf

    content {
      port               = _conf.value.port
      port_name          = _conf.value.port_name
      port_specification = _conf.value.port_specification
      grpc_service_name  = _conf.value.grpc_service_name
    }
  }

  dynamic "log_config" {
    for_each = var.log_config != null ? [var.log_config] : []
    iterator = _conf

    content {
      enable = _conf.value.enable
    }
  }
}

resource "google_compute_region_health_check" "main" {
  provider = google-beta
  for_each = { for v in local.regional_hc : v.name => v }

  name    = each.value.name
  project = var.project
  region  = var.region

  check_interval_sec  = each.value.check_interval_sec
  healthy_threshold   = each.value.healthy_threshold
  unhealthy_threshold = each.value.unhealthy_threshold
  timeout_sec         = each.value.timeout_sec

  dynamic "http_health_check" {
    for_each = var.http_health_check != null ? [var.http_health_check] : []
    iterator = _conf

    content {
      host               = _conf.value.host
      request_path       = _conf.value.request_path
      response           = _conf.value.response
      port               = _conf.value.port
      port_name          = _conf.value.port_name
      proxy_header       = _conf.value.proxy_header
      port_specification = _conf.value.port_specification
    }
  }

  dynamic "https_health_check" {
    for_each = var.https_health_check != null ? [var.https_health_check] : []
    iterator = _conf

    content {
      host               = _conf.value.host
      request_path       = _conf.value.request_path
      response           = _conf.value.response
      port               = _conf.value.port
      port_name          = _conf.value.port_name
      proxy_header       = _conf.value.proxy_header
      port_specification = _conf.value.port_specification
    }
  }

  dynamic "tcp_health_check" {
    for_each = var.tcp_health_check != null ? [var.tcp_health_check] : []
    iterator = _conf

    content {
      request            = _conf.value.request
      response           = _conf.value.response
      port               = _conf.value.port
      port_name          = _conf.value.port_name
      proxy_header       = _conf.value.proxy_header
      port_specification = _conf.value.port_specification
    }
  }

  dynamic "ssl_health_check" {
    for_each = var.ssl_health_check != null ? [var.ssl_health_check] : []
    iterator = _conf

    content {
      request            = _conf.value.request
      response           = _conf.value.response
      port               = _conf.value.port
      port_name          = _conf.value.port_name
      proxy_header       = _conf.value.proxy_header
      port_specification = _conf.value.port_specification
    }
  }

  dynamic "http2_health_check" {
    for_each = var.http2_health_check != null ? [var.http2_health_check] : []
    iterator = _conf

    content {
      host               = _conf.value.host
      request_path       = _conf.value.request_path
      response           = _conf.value.response
      port               = _conf.value.port
      port_name          = _conf.value.port_name
      proxy_header       = _conf.value.proxy_header
      port_specification = _conf.value.port_specification
    }
  }

  dynamic "grpc_health_check" {
    for_each = var.grpc_health_check != null ? [var.grpc_health_check] : []
    iterator = _conf

    content {
      port               = _conf.value.port
      port_name          = _conf.value.port_name
      port_specification = _conf.value.port_specification
      grpc_service_name  = _conf.value.grpc_service_name
    }
  }

  dynamic "log_config" {
    for_each = var.log_config != null ? [var.log_config] : []
    iterator = _conf

    content {
      enable = _conf.value.enable
    }
  }
}
