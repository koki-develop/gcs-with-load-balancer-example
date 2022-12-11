resource "google_compute_global_address" "main" {
  name = "${local.name}-address"
}

resource "google_compute_backend_bucket" "main" {
  name        = "${local.name}-backend"
  bucket_name = google_storage_bucket.main.name
}

resource "google_compute_url_map" "main" {
  name            = "${local.name}-urlmap"
  default_service = google_compute_backend_bucket.main.id
}

resource "google_compute_url_map" "http_to_https" {
  name = "${local.name}-urlmap-http-to-https"
  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_managed_ssl_certificate" "main" {
  name = "${local.name}-cert"
  managed {
    domains = [local.domain]
  }
}

resource "google_compute_target_http_proxy" "main" {
  name    = "${local.name}-http"
  url_map = google_compute_url_map.http_to_https.id
}

resource "google_compute_target_https_proxy" "main" {
  name    = "${local.name}-https"
  url_map = google_compute_url_map.main.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.main.id
  ]
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "${local.name}-lb-http"
  port_range = "80"
  target     = google_compute_target_http_proxy.main.id
  ip_address = google_compute_global_address.main.id
}

resource "google_compute_global_forwarding_rule" "https" {
  name       = "${local.name}-lb-https"
  port_range = "443"
  target     = google_compute_target_https_proxy.main.id
  ip_address = google_compute_global_address.main.id
}
