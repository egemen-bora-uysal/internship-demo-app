#Workload Identity Module for Kubernetes Engine
module "kubernetes-engine_workload-identity" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "~> 22.0"

  name         = "${var.demo_name}-wi"
  project_id   = var.project_id
  namespace    = "default"
  location     = var.zone
  cluster_name = var.cluster_name

  roles = [
    "roles/editor",
    "roles/container.developer"]

  depends_on = [
    module.kubernetes-engine_private-cluster
  ]
}

#Service account role assignation
resource "google_project_iam_member" "cloudbuild_container_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"
}
