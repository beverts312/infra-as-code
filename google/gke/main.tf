resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_container_cluster" "primary" {
  name                     = var.name
  location                 = var.region
  cluster_ipv4_cidr        = var.cluster_ipv4_cidr
  remove_default_node_pool = true
  initial_node_count       = 1

  # private_cluster_config {
  #   enable_private_endpoint = true
  #   enable_private_nodes    = true
  #   master_ipv4_cidr_block  = "
  # }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var-name}-worker-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
