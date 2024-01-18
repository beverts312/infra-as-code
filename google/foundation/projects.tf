module "core-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "core"
  project_id = "main-411208"
  org_id     = var.org_id
  folder_id  = module.cs-common.ids["common"]

  billing_account = var.billing_account
}

module "prod-projects" {
  for_each = var.prod_projects
  source   = "terraform-google-modules/project-factory/google"
  version  = "~> 14.2"

  name       = each.key
  project_id = each.value.id
  org_id     = var.org_id
  folder_id  = module.cs-envs.ids["prod"]

  billing_account = var.billing_account
}

module "nonprod-projects" {
  for_each = var.nonprod_projects
  source   = "terraform-google-modules/project-factory/google"
  version  = "~> 14.2"

  name       = each.key
  project_id = each.value.id
  org_id     = var.org_id
  folder_id  = module.cs-envs.ids["nonprod"]

  billing_account = var.billing_account
}
