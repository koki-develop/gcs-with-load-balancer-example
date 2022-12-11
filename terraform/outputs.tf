output "domain" {
  value = local.domain
}

output "address" {
  value = google_compute_global_address.main.address
}
