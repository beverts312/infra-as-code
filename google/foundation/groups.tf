provider "google-beta" {
  user_project_override = true
  billing_project       = var.core_project.id
}

module "core-service" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.6"

  id           = "core-service@${data.google_organization.org.domain}"
  display_name = "core-service"
  customer_id  = data.google_organization.org.directory_customer_id
  types = [
    "default",
    "security",
  ]
}

module "data-service" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.6"

  id           = "data-service@${data.google_organization.org.domain}"
  display_name = "data-service"
  customer_id  = data.google_organization.org.directory_customer_id
  types = [
    "default",
    "security",
  ]
}

