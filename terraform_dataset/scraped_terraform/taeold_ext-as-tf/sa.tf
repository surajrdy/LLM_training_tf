resource "google_service_account" "sa" {
  account_id = "ext-${var.extension_name}"
}
