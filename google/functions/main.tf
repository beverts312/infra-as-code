locals {
  project = "b4llz-functions"
  package_name = "function.zip"
}

resource "google_storage_bucket" "bucket" {
  name     = "${local.project}-gcf-source"  # Every bucket name must be globally unique
  location = "US"
  uniform_bucket_level_access = true
}

data "archive_file" "function_src" {
  type = "zip"
  source_dir = "function-code"
  output_path = local.package_name
}

resource "google_storage_bucket_object" "object" {
  name   = "function.${data.archive_file.function_src.output_md5}.zip"
  bucket = google_storage_bucket.bucket.name
  source = "function.zip" 
}

resource "google_cloudfunctions2_function" "function" {
  name = "function-v2"
  location = "us-central1"
  description = "a new function"

  build_config {
    runtime = "python311"
    entry_point = "do_it"
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object.name
      }
    }
    
  }

  service_config {
    max_instance_count  = 1
    available_memory    = "256M"
    timeout_seconds     = 60
    ingress_settings = "ALLOW_INTERNAL_ONLY"
    
  }
}

resource "google_cloudfunctions2_function_iam_member" "function_iam_member" {
  project = google_cloudfunctions2_function.function.project
  cloud_function = google_cloudfunctions2_function.function.name
  role = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

output "function_uri" { 
  value = google_cloudfunctions2_function.function.service_config[0].uri
}