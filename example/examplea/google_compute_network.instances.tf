# holden:ignore:HLD_GCP_093: This is just an example
# holden:ignore:HLD_GCP_303: This is just an example
resource "google_compute_network" "instances" {
  name                            = "instances-network"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
}
