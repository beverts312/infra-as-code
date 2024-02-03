variable "billing_account" {
  description = "The ID of the billing account to associate projects with"
  type        = string
}

variable "org_id" {
  description = "The organization id for the associated resources"
  type        = string
}

variable "org_domain" {
  description = "value of the organization domain"
  type        = string
}

variable "folders" {
  description = "The list of folders to create under the organization"
  type        = list(string)
}

variable "prod_projects" {
  description = "The list of prod projects to create under the organization"
  type = map(object({
    id = string
    subnets = list(object({
      name = string
      cidr = string
      region = string
      secondary_ranges = list(object({
        name = string
        cidr = string
      }))
    }))
    enabled_apis = list(string)
  }))
}

variable "nonprod_projects" {
  description = "The list of non-prod projects to create under the organization"
  type = map(object({
    id = string
    subnets = list(object({
      name = string
      cidr = string
      region = string
      secondary_ranges = list(object({
        name = string
        cidr = string
      }))
    }))
    enabled_apis = list(string)
  }))
}

variable "core_project" {
  description = "Core Project Properties"
  type = object({
    id = string
    subnets = list(object({
      name = string
      cidr = string
      region = string
      secondary_ranges = list(object({
        name = string
        cidr = string
      }))
    }))
    enabled_apis = list(string)
  })
}

variable "logging_bucket_name" {
  description = "The name of the logging bucket"
  type        = string
}

variable "primary_region" {
  type = string
}

variable "secondary_region" {
  type = string
}