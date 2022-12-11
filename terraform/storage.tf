resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "google_storage_bucket" "main" {
  name                        = "${local.name}-bucket-${random_id.bucket_suffix.hex}"
  location                    = var.region
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"
  force_destroy               = true
}

resource "google_storage_bucket_object" "dummy" {
  name         = "images/dummy.png"
  source       = "${path.module}/dummy.png"
  content_type = "image/png"

  bucket = google_storage_bucket.main.name
}
