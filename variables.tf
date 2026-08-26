variable "name" {
  type        = string
  description = "Base name of the instance template and the instance created from it"

  validation {
    condition     = can(regex("^[a-z][-a-z0-9]{0,45}$", var.name))
    error_message = "var.name must be lowercase, start with a letter and be at most 46 characters"
  }
}

variable "region" {
  type        = string
  description = "Region of the instance template"
  default     = "europe-west2"

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "var.region must be a non-empty string"
  }
}

variable "zone" {
  type        = string
  description = "Zone the instance is created in"
  default     = "europe-west2-a"

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]-[a-z]$", var.zone))
    error_message = "var.zone must be a zone such as europe-west2-a"
  }
}

variable "machine_type" {
  type        = string
  description = "Machine type of the template"
  default     = "e2-standard-2"

  validation {
    condition     = length(trimspace(var.machine_type)) > 0
    error_message = "var.machine_type must be a non-empty string"
  }
}

variable "source_image" {
  type        = string
  description = "Boot image the template uses, pinned to a specific image rather than a family"

  validation {
    condition     = length(trimspace(var.source_image)) > 0
    error_message = "var.source_image must be a non-empty string"
  }
}

variable "subnetwork" {
  type        = string
  description = "Self-link of the subnetwork instances attach to. No access config is set, so instances get no external IP"

  validation {
    condition     = length(trimspace(var.subnetwork)) > 0
    error_message = "var.subnetwork must be a non-empty string"
  }
}

variable "service_account" {
  type        = string
  description = "Email of the service account instances run as"

  validation {
    condition     = can(regex("^[^@]+@[^@]+$", var.service_account))
    error_message = "var.service_account must be a service account email address"
  }

  validation {
    condition     = !can(regex("(compute@developer|appspot)[.]gserviceaccount[.]com$", var.service_account))
    error_message = "var.service_account must not be a default Compute or App Engine service account"
  }
}

variable "kms_key_name" {
  type        = string
  description = "Self-link of the Cloud KMS key used to encrypt boot disks (CMEK)"
  sensitive   = true

  validation {
    condition     = length(trimspace(var.kms_key_name)) > 0
    error_message = "var.kms_key_name must be a non-empty string"
  }
}

variable "boot_disk_size_gb" {
  type        = number
  description = "Boot disk size, in GB"
  default     = 50

  validation {
    condition     = var.boot_disk_size_gb >= 10
    error_message = "var.boot_disk_size_gb must be at least 10"
  }
}

variable "create_instance" {
  type        = bool
  description = "Whether to create an instance from the template"
  default     = false
}

variable "labels" {
  type        = map(string)
  description = "Labels applied to the template and the instance"
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.labels : can(regex("^[a-z][a-z0-9_-]{0,62}$", k))])
    error_message = "var.labels keys must be lowercase and start with a letter"
  }
}

variable "oauth_scopes" {
  type        = list(string)
  description = "OAuth scopes granted to the attached service account. cloud-platform is rejected, grant IAM roles instead"

  default = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
  ]

  validation {
    condition     = !anytrue([for s in var.oauth_scopes : can(regex("(^cloud-platform$|/auth/cloud-platform$)", s))])
    error_message = "var.oauth_scopes must not include the cloud-platform scope"
  }
}

variable "enable_confidential_compute" {
  type        = bool
  description = "Whether instances run as Confidential VMs. Requires a machine type and image that support it"
  default     = true
}
