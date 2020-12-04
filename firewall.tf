resource "google_compute_firewall" "allow_fw" {
  count         = length(var.source_ranges) != 0 ? 1 : 0
  name          = "vpc-${var.network}-firewall-${var.rule-name}"
  description   = "Creates firewall rule for target instances"
  network       = var.network

  allow {
    protocol = var.protocol
    ports    = var.protocol == "tcp" || var.protocol == "udp" ? var.ports : []
  }

  target_tags   = var.target_tags
  source_ranges = var.source_ranges
}

resource "google_compute_firewall" "allow-fromall" {
  count       = length(var.source_ranges) != 0 ? 0 : length(var.source_tags) != 0 ? 0 : 1
  name          = "vpc-${var.network}-firewall-${var.rule-name}"
  network     = var.network
  allow {
    protocol  = var.protocol
    ports     = var.ports
  }
  target_tags = var.target_tags
}

resource "google_compute_firewall" "allow-sourcetag" {
  count       = length(var.source_tags) != 0 ? 1 : 0
  name          = "vpc-${var.network}-firewall-${var.rule-name}"
  network     = var.network
  allow {
    protocol  = var.protocol
    ports     = var.ports
  }
  source_tags = var.source_tags
  target_tags = var.target_tags
}