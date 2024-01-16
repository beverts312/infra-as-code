resource "google_project_service" "sourcerepos" {
  for_each = toset(var.core_apis)
  project  = var.project_id
  service  = each.value

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}
