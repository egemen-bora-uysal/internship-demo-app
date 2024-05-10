#Create Subnet for given VPC
resource "google_compute_subnetwork" "vpc_subnet" {
  name                     = "${google_compute_network.vpc_network.name}-subnet"
  network                  = google_compute_network.vpc_network.name
  ip_cidr_range            = var.subnet_ip_range
  private_ip_google_access = true
  region                   = var.region

  secondary_ip_range {
    range_name    = var.ip_range_pods
    ip_cidr_range = var.subnet_pod_ip_range
  }

  secondary_ip_range {
    range_name    = var.ip_range_services
    ip_cidr_range = var.subnet_svc_ip_range
  }
}
