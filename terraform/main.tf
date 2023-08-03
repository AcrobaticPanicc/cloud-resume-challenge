provider "google" {
  credentials = file("${path.module}/gcp-key.json")
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_storage_bucket" "website_bucket" {
  name          = var.bucket_name
  location      = "US"
  website {
    main_page_suffix = var.html_page
  }
}

resource "google_storage_bucket_object" "website_content" {
  name   = var.html_page
  bucket = google_storage_bucket.website_bucket.name
  source = var.html_page
}

resource "google_storage_bucket_iam_binding" "bucket_public" {
  bucket = google_storage_bucket.website_bucket.name
  role   = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}

resource "google_compute_global_address" "ip_address" {
  name = var.reservation_name
}

resource "google_compute_backend_bucket" "backend" {
  name        = var.neg_name
  bucket_name = google_storage_bucket.website_bucket.name
  enable_cdn  = true
}

resource "google_compute_url_map" "url_map" {
  name = var.url_map_name
  default_service = google_compute_backend_bucket.backend.self_link
}

resource "google_compute_managed_ssl_certificate" "ssl_cert" {
  name    = var.certificate_name
  managed {
    domains = [var.domain_name]
  }
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name             = var.target_https_proxy_name
  url_map          = google_compute_url_map.url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_cert.self_link]
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = var.forwarding_rule_name
  ip_address = google_compute_global_address.ip_address.address
  target     = google_compute_target_https_proxy.https_proxy.self_link
  port_range = "443"
}
