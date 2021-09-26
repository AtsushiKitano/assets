resource "google_folder" "root_folder" {
  for_each = toset(var.root_folder_names)

  display_name = each.value
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "child_folder" {
  for_each = { for v in var.child_folders : "${v.root_folder_name}/${v.name}" => v }

  display_name = each.value.name
  parent       = join("/", ["organizations", google_folder.root_folder[each.value.root_folder_name].id])
}

resource "google_folder" "gland_child_folder" {
  for_each = if(length(var.child_folders) > 0) ? { for v in var.gland_child_folders : "${v.parent_folder_name}/${v.name}" => v } : {}

  display_name = each.value.name
  parent       = join("/", ["organizations", google_folder.child_folder[each.value.parent_folder_name].id])
}

resource "google_folder" "gland_glandson_folder" {
  for_each = if(length(var.gland_child_folders) > 0 && length(var.child_folders) > 0) ? { for v in var.gland_glandson_folders : "${v.parent_folder_name}/${v.name}" => v } : {}

  display_name = each.value.name
  parent       = join("/", ["organizations", google_folder.gland_child_folder[each.value.parent_folder_name].id])
}
