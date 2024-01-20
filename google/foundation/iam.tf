module "nonprod-computeinstanceAdminv1" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [
    module.cs-envs.ids["nonprod"],
  ]
  bindings = {
    "roles/compute.instanceAdmin.v1" = [
      "group:gcp-developers@${data.google_organization.org.domain}",
    ]
  }
}

module "nonprod-containeradmin" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders = [
    module.cs-envs.ids["nonprod"],
  ]
  bindings = {
    "roles/container.admin" = [
      "group:gcp-developers@${data.google_organization.org.domain}",
    ]
  }
}

module "loggingviewer" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.4"

  projects = [
    module.core-project.project_id,
  ]
  bindings = {
    "roles/logging.viewer" = [
      "group:gcp-logging-viewers@${data.google_organization.org.domain}",
    ]
  }
}
