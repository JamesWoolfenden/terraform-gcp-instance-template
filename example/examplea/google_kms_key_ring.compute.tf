resource "google_kms_key_ring" "compute" {
  name     = "compute-keyring"
  location = "europe-west2"
}
