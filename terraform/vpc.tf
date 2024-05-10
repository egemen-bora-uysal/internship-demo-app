#Create VPC
resource "google_compute_network" "vpc_network" {
  name                    = "${var.demo_name}-vpc-network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}


