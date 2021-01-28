resource "google_sql_database_instance" "main" {
  name             = var.sql_instance.name
  region           = var.sql_instance.region
  database_version = var.sql_instance.database_version
  project          = var.project

  settings {
    tier              = var.sql_instance.tier
    activation_policy = var.activation_policy
    availability_type = var.availability_type
    disk_autoresize   = var.disk_autoresize
    disk_size         = ! var.disk_autoresize ? var.disk_size : null
    disk_type         = var.disk_type
    pricing_plan      = var.pricing_plan

    dynamic "database_flags" {
      for_each = var.flags
      iterator = _conf

      content {
        name  = _conf.value.name
        value = _conf.value.value
      }
    }

    dynamic "backup_configuration" {
      for_each = var.backup_configuration != null ? [var.backup_configuration] : []
      iterator = _conf

      content {
        binary_log_enabled             = contains(split("_", var.database_version), "MYSQL") ? _conf.value.binary_log_enabled : null
        enabled                        = _conf.value.enabled
        start_time                     = _conf.value.start_time
        point_in_time_recovery_enabled = contains(split("_", var.database_version), "POSTGRES") ? _conf.value.point_in_time_recovery_enabled : null
      }
    }

    dynamic "ip_configuration" {
      for_each = var.ip_configuration != null ? [var.ip_configuration] : []
      iterator = _conf

      content {
        ipv4_enabled    = _conf.value.ipv4_enabled
        private_network = _conf.value.private_network
        require_ssl     = _conf.value.require_ssl

        dynamic "authorized_networks" {
          for_each = var.authorized_networks
          iterator = _var

          content {
            expiration_time = _var.value.expiration_time
            name            = _var.value.name
            value           = _var.value.value
          }
        }
      }
    }

    dynamic "location_preference" {
      for_each = var.location_preference != null ? [var.location_preference] : []
      iterator = _conf

      content {
        follow_gae_application = _conf.value.follow_gae_application
        zone                   = _conf.value.zone
      }
    }

    dynamic "maintenance_window" {
      for_each = var.maintenance != null ? [var.maintenance] : []
      iterator = _conf

      content {
        day          = _conf.value.day
        hour         = _conf.value.hour
        update_track = _conf.value.update_track
      }
    }
  }

  dynamic "replica_configuration" {
    for_each = var.replica_configuration != null ? [var.replica_configuration] : []
    iterator = _conf

    content {
      dump_file_path            = _conf.value.dump_file_path
      failover_target           = _conf.value.failover_target
      master_heartbeat_period   = _conf.value.master_heartbeat_period
      connect_retry_interval    = _conf.value.connect_retry_interval
      username                  = _conf.value.username
      password                  = _conf.value.password
      ssl_cipher                = var.sslcipher
      verify_server_certificate = var.verify_server_certificate
      client_key                = var.client_key
      client_certificate        = var.client_certificate
      ca_certificate            = var.ca_certificate
    }
  }
}

resource "google_sql_database" "main" {
  for_each = { for v in var.database : v.name => v }

  name      = each.value.name
  instance  = google_sql_database_instance.main.name
  charset   = each.value.charset
  collation = each.value.collation
  project   = var.project
}
