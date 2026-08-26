resource "google_project_service_identity" "compute" {
  provider = google-beta
  service  = "compute.googleapis.com"
}
