# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
# holden:ignore:HLD_TF_065: for expansion
module "template" {
  source          = "../../"
  name            = "example-template"
  region          = "europe-west2"
  zone            = "europe-west2-a"
  source_image    = data.google_compute_image.debian.self_link
  subnetwork      = google_compute_subnetwork.instances.id
  service_account = google_service_account.instances.email
  kms_key_name    = google_kms_crypto_key.compute.id

  labels = {
    owner = "holden"
  }

  depends_on = [google_kms_crypto_key_iam_member.compute_service_agent]
}
