terraform {
  backend "gcs" {
    bucket = "koki-test-tfstates"
    prefix = "gcs-with-load-balancer-example"
  }
}
