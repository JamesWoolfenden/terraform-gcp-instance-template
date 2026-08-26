resource "google_compute_subnetwork" "instances" {
  name                     = "instances-subnet"
  ip_cidr_range            = "10.120.0.0/24"
  region                   = "europe-west2"
  network                  = google_compute_network.instances.id
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
