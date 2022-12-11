resource "google_compute_global_address" "main" {
  name = "${local.name}-address"
}

resource "google_compute_backend_bucket" "main" {
  name        = "${local.name}-backend"
  bucket_name = google_storage_bucket.main.name
}

resource "google_compute_url_map" "main" {
  name            = "${local.name}-urlmap-http"
  default_service = google_compute_backend_bucket.main.id
}

resource "google_compute_target_http_proxy" "main" {
  name    = "${local.name}-http"
  url_map = google_compute_url_map.main.id
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "${local.name}-lb-http"
  port_range = "80"
  target     = google_compute_target_http_proxy.main.id
  ip_address = google_compute_global_address.main.id
}
