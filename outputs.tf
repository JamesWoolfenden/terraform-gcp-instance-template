output "template_id" {
  value       = google_compute_region_instance_template.main.id
  description = "ID of the regional instance template"
}

output "instance_id" {
  value       = try(google_compute_instance_from_template.main[0].id, null)
  description = "ID of the instance created from the template, null when var.create_instance is false"
}
