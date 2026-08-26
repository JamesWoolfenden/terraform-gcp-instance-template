# terraform-gcp-instance-template

[![Build Status](https://github.com/JamesWoolfenden/terraform-gcp-instance-template/workflows/Verify/badge.svg?branch=master)](https://github.com/JamesWoolfenden/terraform-gcp-instance-template)
[![Latest Release](https://img.shields.io/github/release/terraform-gcp-instance-template.svg)](https://github.com/JamesWoolfenden/terraform-gcp-instance-template/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-gcp-instance-template.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-gcp-instance-template/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.5.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

Terraform module for a regional instance template with shielded VM, OS Login,
CMEK boot disks and no external IP, plus an optional instance created from it.
Exercises holden's google_compute_region_instance_template and
google_compute_instance_from_template policies.

## Usage

Add **module.template.tf** to your code:-

```terraform
module "template" {
  source          = "jameswoolfenden/instance-template/gcp"
  version         = "0.0.1"
  name            = "example-template"
  region          = "europe-west2"
  source_image    = data.google_compute_image.debian.self_link
  subnetwork      = google_compute_subnetwork.instances.id
  service_account = google_service_account.instances.email
  kms_key_name    = google_kms_crypto_key.compute.id
}
```

The template uses name_prefix with create_before_destroy, because instance
templates are immutable — any change makes a new one, and the old one cannot
be deleted while a managed instance group still references it.

There is no access_config block, so instances have no external IP; the
subnetwork needs Private Google Access or Cloud NAT. var.service_account
rejects the default Compute service account.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_compute_instance_from_template.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_from_template) | resource |
| [google_compute_region_instance_template.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_template) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_boot_disk_size_gb"></a> [boot\_disk\_size\_gb](#input\_boot\_disk\_size\_gb) | Boot disk size, in GB | `number` | `50` | no |
| <a name="input_create_instance"></a> [create\_instance](#input\_create\_instance) | Whether to create an instance from the template | `bool` | `false` | no |
| <a name="input_enable_confidential_compute"></a> [enable\_confidential\_compute](#input\_enable\_confidential\_compute) | Whether instances run as Confidential VMs. Requires a machine type and image that support it | `bool` | `true` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | Self-link of the Cloud KMS key used to encrypt boot disks (CMEK) | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels applied to the template and the instance | `map(string)` | `{}` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Machine type of the template | `string` | `"e2-standard-2"` | no |
| <a name="input_name"></a> [name](#input\_name) | Base name of the instance template and the instance created from it | `string` | n/a | yes |
| <a name="input_oauth_scopes"></a> [oauth\_scopes](#input\_oauth\_scopes) | OAuth scopes granted to the attached service account. cloud-platform is rejected, grant IAM roles instead | `list(string)` | <pre>[<br/>  "https://www.googleapis.com/auth/devstorage.read_only",<br/>  "https://www.googleapis.com/auth/logging.write",<br/>  "https://www.googleapis.com/auth/monitoring.write"<br/>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | Region of the instance template | `string` | `"europe-west2"` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | Email of the service account instances run as | `string` | n/a | yes |
| <a name="input_source_image"></a> [source\_image](#input\_source\_image) | Boot image the template uses, pinned to a specific image rather than a family | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Self-link of the subnetwork instances attach to. No access config is set, so instances get no external IP | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone the instance is created in | `string` | `"europe-west2-a"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | ID of the instance created from the template, null when var.create\_instance is false |
| <a name="output_template_id"></a> [template\_id](#output\_template\_id) | ID of the regional instance template |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Help

**Got a question?**

File a GitHub [issue](https://github.com/JamesWoolfenden/terraform-gcp-instance-template/issues).

## Copyrights

Copyright © 2019-2026 [Jim Woolfenden](https://github.com/JamesWoolfenden)

## License

See [LICENSE](LICENSE) for full details.


<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "compute.instanceTemplates.create",
    "compute.instanceTemplates.delete",
    "compute.instanceTemplates.get",
    "compute.instanceTemplates.useReadOnly",
    "compute.instances.create",
    "compute.instances.delete",
    "compute.instances.get",
    "compute.instances.setLabels",
    "compute.instances.setMetadata",
    "compute.instances.setServiceAccount",
    "compute.zoneOperations.get"
  ]
}

# plan role
resource "google_project_iam_custom_role" "terraform_pike_plan" {
  project     = "pike-477416"
  role_id     = "terraform_pike_plan"
  title       = "terraform_pike_plan"
  description = "A user with least privileges"
  permissions = [
    "compute.instanceTemplates.get",
    "compute.instanceTemplates.useReadOnly",
    "compute.instances.get"
  ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->
