#Set firewall rule allow all internal connections
resource "google_compute_firewall" "allow_internal" {
  name    = "${google_compute_network.vpc_network.name}-allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "all"
  }

  source_ranges = [
    var.subnet_ip_range
  ]
}
