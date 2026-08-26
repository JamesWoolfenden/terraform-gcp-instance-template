resource "google_compute_instance_from_template" "main" {
  count = var.create_instance ? 1 : 0

  name                     = var.name
  zone                     = var.zone
  source_instance_template = google_compute_region_instance_template.main.id
  deletion_protection      = true
  can_ip_forward           = false

  # Repeated from the template so the instance is legible on its own: an override
  # here is what actually applies, and a reader of this resource cannot see the
  # template's settings.
  boot_disk {
    kms_key_self_link = var.kms_key_name
  }

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
}
