locals {
  core_subnets = [flatten([for subnet in var.core_project.subnets : {
      subnet_name               = "${var.core_project.id}-${subnet.name}"
      subnet_ip                 = subnet.cidr
      subnet_region             = subnet.region
      subnet_private_access     = true
      subnet_flow_logs          = false
  }])]
  nonprod_subnets = [
    for p in keys(var.nonprod_projects) : flatten([
      for subnet in var.nonprod_projects[p].subnets : {
        subnet_name               = "${p}-${subnet.name}-np-${subnet.region}"
        subnet_ip                 = subnet.cidr
        subnet_region             = subnet.region
        subnet_private_access     = true
        subnet_flow_logs          = false
      }
    ])
  ]
  prod_subnets = [
    for p in keys(var.prod_projects) : flatten([
      for subnet in var.prod_projects[p].subnets : {
        subnet_name               = "${p}-${subnet.name}-pd"
        subnet_ip                 = subnet.cidr
        subnet_region             = subnet.region
        subnet_private_access     = true
        subnet_flow_logs          = true
        subnet_flow_logs_sampling = "0.5"
        subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        subnet_flow_logs_interval = "INTERVAL_10_MIN"
      }
    ])
  ]
  subnets = flatten(concat([local.core_subnets, local.nonprod_subnets, local.prod_subnets]))
  nonprod_secondary_ranges = merge([for p in keys(var.nonprod_projects) : {for subnet in var.nonprod_projects[p].subnets : 
    "${p}-${subnet.name}-np-${subnet.region}" => [
      for range in subnet.secondary_ranges : {
        range_name = range.name
        ip_cidr_range = range.cidr
      }
    ]
  }]...)
  prod_secondary_ranges = merge([for p in keys(var.prod_projects) : {for subnet in var.prod_projects[p].subnets : 
    "${p}-${subnet.name}-pd-${subnet.region}" => [
      for range in subnet.secondary_ranges : {
        range_name = range.name
        ip_cidr_range = range.cidr
      }
    ]
  }]...)
  core_secondary_ranges = {for subnet in var.core_project.subnets : 
    "${var.core_project.id}-${subnet.name}" => [
      for range in subnet.secondary_ranges : {
        range_name = range.name
        ip_cidr_range = range.cidr
      }
    ]
  }
  secondary_ranges = merge(local.core_secondary_ranges, local.nonprod_secondary_ranges, local.prod_secondary_ranges)
}

module "shared-vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.core-project.project_id
  network_name = "shared-vpc"

  subnets = local.subnets
  secondary_ranges = local.secondary_ranges

  firewall_rules = []
}
