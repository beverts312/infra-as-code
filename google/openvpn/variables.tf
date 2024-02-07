variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "name" {
  type = string
}

variable "network" {
  type = string  
}

variable "subnetwork" {
  type = string
}

variable "init_password" {
  type = string
  sensitive = true
}