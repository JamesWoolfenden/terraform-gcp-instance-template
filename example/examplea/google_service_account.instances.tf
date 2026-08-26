resource "google_service_account" "instances" {
  account_id   = "instance-workloads"
  display_name = "Compute Engine workload service account"
}
