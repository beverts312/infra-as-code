resource "google_project_service" "workflows" {
  service            = "workflows.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "workflows_service_account" {
  account_id   = "sample-workflows-sa"
  display_name = "Sample Workflows Service Account"
}

resource "google_workflows_workflow" "workflows_example" {
  name            = var.name
  region          = "us-central1"
  description     = "A sample workflow"
  user_env_vars = {
    url = var.function_uri
  }
  service_account = google_service_account.workflows_service_account.id
  source_contents = file("workflow.yaml")
  depends_on = [google_project_service.workflows]
}