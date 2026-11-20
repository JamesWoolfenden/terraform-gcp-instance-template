resource "google_kms_crypto_key" "compute" {
  name            = "compute-key"
  key_ring        = google_kms_key_ring.compute.id
  rotation_period = "2592000s"

  destroy_scheduled_duration = "2592000s"

  lifecycle {
    prevent_destroy = true
  }
}
