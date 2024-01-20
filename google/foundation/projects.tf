module "core-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name       = "core"
  project_id = var.core_project.id
  org_id     = var.org_id
  folder_id  = module.cs-common.ids["common"]

  billing_account = var.billing_account

  activate_apis = [
    "cloudidentity.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "servicenetworking.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
  ]
}

module "prod-projects" {
  for_each = var.prod_projects
  source   = "terraform-google-modules/project-factory/google//modules/svpc_service_project"
  version  = "~> 14.2"

  name       = each.key
  project_id = each.value.id
  org_id     = var.org_id
  folder_id  = module.cs-envs.ids["prod"]

  billing_account = var.billing_account

  shared_vpc = module.shared-vpc.project_id
  shared_vpc_subnets = [for subnet in each.value.subnets : module.shared-vpc.subnets["${subnet.region}/${each.key}-${subnet.name}-pd"].self_link]
  domain = data.google_organization.org.domain
}

module "nonprod-projects" {
  for_each = var.nonprod_projects
  source   = "terraform-google-modules/project-factory/google//modules/svpc_service_project"
  version  = "~> 14.2"

  name       = each.key
  project_id = each.value.id
  org_id     = var.org_id
  folder_id  = module.cs-envs.ids["nonprod"]

  billing_account = var.billing_account

  shared_vpc = module.shared-vpc.project_id
  shared_vpc_subnets = [for subnet in each.value.subnets : module.shared-vpc.subnets["${subnet.region}/${each.key}-${subnet.name}-np"].self_link]
  domain = data.google_organization.org.domain
}
