data "google_client_config" "provider" {}
data "google_container_cluster" "primary" {
  name = var.cluster_name
  location = var.region
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.primary.endpoint}"  
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}

resource "kubernetes_namespace" "default" {
  metadata {
    name = var.name
  }
}

resource "kubernetes_manifest" "configconnector" {
  manifest = {
    "apiVersion" = "core.cnrm.cloud.google.com/v1beta1"
    "kind" = "ConfigConnectorContext"
    "metadata" = {
      "name" = "configconnectorcontext.core.cnrm.cloud.google.com"
      "namespace" = kubernetes_namespace.default.metadata.0.name
    }
    "spec" = {
      "googleServiceAccount" = google_service_account.default.email
    }
  }
}

module "workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = google_service_account.default.account_id
  namespace           = var.name
  project_id          = var.project_id
  use_existing_gcp_sa = true
  roles               = ["roles/iam.workloadIdentityUser", "roles/compute.admin"]
}

resource "google_service_account" "default" {
  account_id   = "${var.name}-gsa"
  display_name = "${var.name} Namespace Service Account"
}

