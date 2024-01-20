module "shared-vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.core-project.project_id
  network_name = "shared-vpc"

  subnets = flatten(concat(
    [flatten([for subnet in var.core_project.subnets : {
        subnet_name               = "${var.core_project.id}-${subnet.name}"
        subnet_ip                 = subnet.cidr
        subnet_region             = subnet.region
        subnet_private_access     = true
        subnet_flow_logs          = false
    }])],
    [for p in keys(var.nonprod_projects) : flatten([for subnet in var.nonprod_projects[p].subnets : {
        subnet_name               = "${p}-${subnet.name}-np"
        subnet_ip                 = subnet.cidr
        subnet_region             = subnet.region
        subnet_private_access     = true
        subnet_flow_logs          = false
    }])],
    [for p in keys(var.prod_projects) : flatten([for subnet in var.prod_projects[p].subnets : {
        subnet_name               = "${p}-${subnet.name}-pd"
        subnet_ip                 = subnet.cidr
        subnet_region             = subnet.region
        subnet_private_access     = true
        subnet_flow_logs          = true
        subnet_flow_logs_sampling = "0.5"
        subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        subnet_flow_logs_interval = "INTERVAL_10_MIN"
    }])]
  ))
  firewall_rules = []
}
