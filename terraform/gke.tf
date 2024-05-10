#Kubernetes Engine module for creating private cluster
module "kubernetes-engine_private-cluster" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "~> 22.0"

  ip_range_pods     = var.ip_range_pods
  ip_range_services = var.ip_range_services

  name       = var.cluster_name
  project_id = var.project_id

  network            = google_compute_network.vpc_network.name
  subnetwork         = google_compute_subnetwork.vpc_subnet.name
  network_policy     = true
  network_project_id = var.project_id

  grant_registry_access    = true
  remove_default_node_pool = true

  regional = false
  zones    = [var.zone]

  release_channel = "REGULAR"

  enable_private_nodes    = true
  master_ipv4_cidr_block  = var.master_pod_ip_range
  enable_private_endpoint = false

  create_service_account = false
  service_account        = "default"



  node_pools = [
    {
      name           = var.node_pool_name
      image_type     = "cos_containerd"
      node_locations = var.zone


      # [AUTOSCALING ENABLED]
      initial_node_count = 2
      min_count          = 2
      max_count          = 5


      # [AUTOSCALING DISABLED]
      # node_count  = 2
      # autoscaling = false


      disk_size_gb = 50
      machine_type = "e2-small"

      auto_upgrade = true
      auto_repair  = true
    }

  ]
  node_pools_metadata = {
    all = {
      disable_legacy_metadata_endpoints = true
    }
  }

}
