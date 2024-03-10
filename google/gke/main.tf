locals {
  cluster_domain = "${var.name}-${var.region}.${var.domain}"
}

data "google_compute_network" "shared-vpc" {
  name = var.network
  project = var.vpc_project_id
}

data "google_compute_subnetwork" "shared-subnet" {
  name = var.subnetwork
  project = var.vpc_project_id
  region = var.region
}

# resource "google_service_account" "default" {
#   account_id   = "${var.name}-gke-sa"
#   display_name = "${var.name} GKE Service Account"
# }

# resource "google_project_iam_member" "gke_sa" {
#   project = var.project_id
#   role    = "roles/editor"
#   member  = "serviceAccount:${google_service_account.default.email}"
# }

# resource "google_container_cluster" "primary" {
#   name                     = var.name
#   location                 = var.region
#   remove_default_node_pool = true
#   initial_node_count       = 1
#   network                  = data.google_compute_network.shared-vpc.self_link
#   subnetwork               = data.google_compute_subnetwork.shared-subnet.self_link
#   ip_allocation_policy  {
#     cluster_secondary_range_name = "pods"
#     services_secondary_range_name = "services"
#   }
#   addons_config {
#     config_connector_config {
#       enabled = true
#     }
#   }
#   workload_identity_config {
#     workload_pool = "${var.project_id}.svc.id.goog"
#   }
# }

# resource "google_container_node_pool" "primary_preemptible_nodes" {
#   name       = "${var.name}-worker-pool"
#   location   = var.region
#   cluster    = google_container_cluster.primary.name
#   node_count = 1

#   node_config {
#     preemptible  = true
#     machine_type = "e2-standard-4"
#     disk_size_gb = 100
#     service_account = google_service_account.default.email
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#   }
# }


module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  project_id = var.project_id
  name       = var.name
  region     = var.region
  network    = data.google_compute_network.shared-vpc.self_link
  subnetwork = data.google_compute_subnetwork.shared-subnet.self_link
  ip_range_pods = "pods"
  ip_range_services = "services"
  create_service_account = true
  network_project_id = var.vpc_project_id

  node_pools = [
    {
      name               = "default-pool"
      machine_type       = "e2-standard-4"
      min_count          = 1
      max_count          = 1
      disk_size_gb       = 100
      service_account    = "default"
      oauth_scopes       = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
      node_locations     = [var.region]
    }
  ]

  depends_on = [
    data.google_compute_network.shared-vpc,
    data.google_compute_subnetwork.shared-subnet
  ]
}

module "dns-private-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "4.0"
  project_id = var.project_id
  type       = "private"
  name       = local.cluster_domain
  domain     = "${local.cluster_domain}."

  private_visibility_config_networks = [
    data.google_compute_network.shared-vpc.self_link
  ]
}