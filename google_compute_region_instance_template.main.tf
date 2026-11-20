resource "google_compute_region_instance_template" "main" {
  name_prefix  = "${var.name}-"
  region       = var.region
  machine_type = var.machine_type

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
    disk_type    = "pd-balanced"
    disk_size_gb = var.boot_disk_size_gb

    disk_encryption_key {
      kms_key_self_link = var.kms_key_name
    }
  }

  network_interface {
    subnetwork = var.subnetwork
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

  confidential_instance_config {
    enable_confidential_compute = var.enable_confidential_compute
  }

  scheduling {
    provisioning_model = "STANDARD"
    preemptible        = false
    automatic_restart  = true
    # Confidential VMs cannot live migrate, so they must terminate on host maintenance
    on_host_maintenance = var.enable_confidential_compute ? "TERMINATE" : "MIGRATE"
  }

  metadata = {
    "enable-oslogin"         = "true"
    "block-project-ssh-keys" = "true"
  }

  labels = var.labels

  lifecycle {
    create_before_destroy = true

    precondition {
      condition     = !var.enable_confidential_compute || can(regex("^(n2d|c2d|c3d|c4d)-", var.machine_type))
      error_message = "var.machine_type must be an N2D, C2D, C3D or C4D machine type when var.enable_confidential_compute is true"
    }
  }
}
