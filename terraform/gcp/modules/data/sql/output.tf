output "database_self_link" {
  value = {
    for v in var.database : v.name => google_sql_database.main[v.name].self_link
  }
}

output "database_id" {
  value = {
    for v in var.database : v.name => google_sql_database.main[v.name].id
  }
}

output "self_link" {
  value = google_sql_database_instance.main.self_link
}

output "connection_name" {
  value = google_sql_database_instance.main.connection_name
}

output "service_account" {
  value = google_sql_database_instance.main.service_account_email_address
}

output "ip_address" {
  value = google_sql_database_instance.main.ip_address.0.ip_address
}

output "time_to_retire" {
  value = google_sql_database_instance.main.ip_address.0.time_to_retire
}

output "ip_type" {
  value = google_sql_database_instance.main.ip_address.0.type
}

output "first_ip_address" {
  value = google_sql_database_instance.main.first_ip_address
}

output "public_ip_address" {
  value = google_sql_database_instance.main.public_ip_address
}

output "private_ip_address" {
  value = google_sql_database_instance.main.private_ip_address
}

