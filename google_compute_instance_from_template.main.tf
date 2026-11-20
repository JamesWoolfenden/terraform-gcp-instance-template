resource "google_compute_instance_from_template" "main" {
  count = var.create_instance ? 1 : 0

  name                     = var.name
  zone                     = var.zone
  source_instance_template = google_compute_region_instance_template.main.id
  deletion_protection      = true
  can_ip_forward           = false

  # Repeated from the template so the instance is legible on its own: an override
  # here is what actually applies, and a reader of this resource cannot see the
  # template's settings. boot_disk is deliberately not repeated: overriding it
  # replaces the template's boot disk (image, type, size and CMEK key) wholesale.

  confidential_instance_config {
    enable_confidential_compute = var.enable_confidential_compute
  }

  service_account {
    email  = var.service_account
    scopes = var.oauth_scopes
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  metadata = {
    "enable-oslogin"         = "true"
    "block-project-ssh-keys" = "true"
  }

  labels = var.labels

  lifecycle {
    # The instance is seeded once from the template. Templates are immutable and
    # replaced on every change, and source_instance_template is ForceNew, so
    # tracking it would try to replace this deletion-protected instance.
    ignore_changes = [source_instance_template]

    precondition {
      condition     = startswith(var.zone, "${var.region}-")
      error_message = "var.zone must be a zone in var.region, the region of the instance template"
    }
  }
}
