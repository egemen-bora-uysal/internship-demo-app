#Providers block for terraform
terraform {
  required_version = "~> 1.2"

  required_providers {

    google = {
      version = "~> 4.30"
      source  = "hashicorp/google"
    }

    kubernetes = {
      version = "~> 2.12"
      source  = "hashicorp/kubernetes"
    }

    random = {
      version = "~> 3.3"
      source  = "hashicorp/random"
    }

    null = {
      version = "~> 3.1"
      source  = "hashicorp/null"
    }

    external = {
      version = "~> 2.2"
      source  = "hashicorp/external"
    }

  }
}

#Individual provider entry
provider "google" {
  project = var.project_id
  region  = var.region
}

#Individual provider entry
provider "kubernetes" {
  host                   = "https://${module.kubernetes-engine_private-cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.kubernetes-engine_private-cluster.ca_certificate)
}

#Google Client config
data "google_client_config" "default" {}
