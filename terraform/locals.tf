locals {
  name   = "gcs-lb"
  domain = "${local.name}.${data.google_dns_managed_zone.main.dns_name}"
}
