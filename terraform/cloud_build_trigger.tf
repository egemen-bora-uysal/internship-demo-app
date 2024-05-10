#Filename trigger for Google Cloud Build upon new push to the repository
resource "google_cloudbuild_trigger" "filename-trigger" {
  name = "${var.demo_name}-trigger"

  trigger_template {
    branch_name = var.branch_name
    repo_name   = var.repo_name
  }

  #Substitutions for cloudbuild yaml file environment variables
  substitutions = {
    _SERVICE_ACCOUNT_NAME = module.kubernetes-engine_workload-identity.k8s_service_account_name
    _K8S_FILE             = var.kubernetes_config
    _IMAGE_REPO           = var.repo_name
    _LOCATION             = var.region
    _CLUSTER_LOCATION     = var.zone
    _CLUSTER_NAME         = var.cluster_name
    _APP_NAME             = var.app_name
  }

  filename = var.cloudbuild_config

  depends_on = [
    module.kubernetes-engine_workload-identity
  ]
}
