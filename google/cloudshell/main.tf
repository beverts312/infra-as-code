resource "google_sourcerepo_repository" "repository" {
  name = var.name
}

resource "google_sourcerepo_repository_iam_member" "member" {
  project    = google_sourcerepo_repository.repository.project
  repository = google_sourcerepo_repository.repository.name
  role       = "roles/writer"
  member     = "user:${var.user}"
}

resource "google_cloudbuild_trigger" "filename-trigger" {
  location = var.region
  trigger_template {
    branch_name = "main"
    repo_name   = google_sourcerepo_repository.repository.name
  }

  filename = "cloudbuild.yaml"
}

resource "local_file" "custom_image_repo_json" {
  content = templatefile(
    "${path.module}/repo/cloudshellcustomimagerepo.json.tftpl",
    {
      project_id = var.project_id
      name       = google_sourcerepo_repository.repository.name
    }
  )
  filename = "${path.module}/repo/.cloudshellcustomimagerepo.json"
}

resource "local_file" "init_repo_script" {
  content = templatefile(
    "${path.module}/repo/init_repo.sh.tftpl",
    {
      user       = var.user
      project_id = var.project_id
      name       = google_sourcerepo_repository.repository.name
    }
  )
  filename        = "${path.module}/repo/init_repo.sh"
  file_permission = "0777"
}
