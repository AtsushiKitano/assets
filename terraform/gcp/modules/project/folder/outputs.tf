output "root_folder_id" {
  value = google_folder.root_folder.id
}

output "child_folder_ids" {
  value = { for v in var.child_folders : v => google_folder.child_folder[v.name].id }
}

output "gland_child_folder_ids" {
  value = { for v in var.gland_child_folders : v => google_folder.gland_child_folder[v.name].id }
}

output "gland_glandson_folder_ids" {
  value = { for v in var.gland_glandson_folders : v => google_folder.gland_glandson_folder[v.name].id }
}
