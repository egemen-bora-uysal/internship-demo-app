# Create Google Cloud router
resource "google_compute_router" "cloud_router" {
  name    = "${var.demo_name}-cloud-router"
  region  = google_compute_subnetwork.vpc_subnet.region
  network = google_compute_network.vpc_network.name
}
