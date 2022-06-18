resource "google_iap_brand" "main" {
  support_email     = var.conf.email
  application_title = var.conf.app_title
  project           = var.project
}

resource "google_iap_client" "main" {
  display_name = var.conf.display_name
  brand        = google_iap_brand.main.id
}
