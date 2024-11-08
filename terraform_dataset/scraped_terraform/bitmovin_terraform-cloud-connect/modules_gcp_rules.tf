locals {
  internal_network_blocks        = ["10.0.0.0/8"]
  bitmovin_static_network_blocks = ["104.199.97.13/32", "35.205.157.162/32"]
}

# enable Compute Engine API
resource "google_project_service" "compute-engine" {
  project = var.project_id
  service = "compute.googleapis.com"
}

# create auto-mode VPC
resource "google_compute_network" "bitmovin_vpc_network" {
  name = var.network_name

  depends_on = [google_project_service.compute-engine]
}

resource "google_compute_firewall" "bitmovin_allow_internal" {
  description   = "For communication between the session manager VM instance and its instance manager VM instances"
  name          = "${google_compute_network.bitmovin_vpc_network.name}-allow-internal"
  network       = google_compute_network.bitmovin_vpc_network.name
  source_ranges = local.internal_network_blocks

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

resource "google_compute_firewall" "bitmovin_allow_ssh" {
  description   = "For incoming commands from the Bitmovin API to control the encoding"
  name          = "${google_compute_network.bitmovin_vpc_network.name}-allow-ssh"
  network       = google_compute_network.bitmovin_vpc_network.name
  source_ranges = local.bitmovin_static_network_blocks

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "bitmovin_encoder_service" {
  description   = "For communication with the service that manages the encoding"
  name          = "${google_compute_network.bitmovin_vpc_network.name}-encoder-service"
  network       = google_compute_network.bitmovin_vpc_network.name
  source_ranges = local.bitmovin_static_network_blocks

  allow {
    protocol = "tcp"
    ports    = ["9999"]
  }
}

resource "google_compute_firewall" "bitmovin_encoder_service_https" {
  description   = "For HTTPS communication with the service that manages the encoding"
  name          = "${google_compute_network.bitmovin_vpc_network.name}-encoder-service-https"
  network       = google_compute_network.bitmovin_vpc_network.name
  source_ranges = local.bitmovin_static_network_blocks

  allow {
    protocol = "tcp"
    ports    = ["9443"]
  }
}

resource "google_compute_firewall" "bitmovin_rtmp_listener" {
  count = var.live_rtmp ? 1 : 0

  description   = "For RTMP live streams"
  name          = "${google_compute_network.bitmovin_vpc_network.name}-rtmp-listener"
  network       = google_compute_network.bitmovin_vpc_network.name
  source_ranges = var.live_ingress_ipv4_network_blocks

  allow {
    protocol = "tcp"
    ports    = ["1935"]
  }
}

resource "google_compute_firewall" "bitmovin_rtmps_listener" {
  count = var.live_rtmp ? 1 : 0

  description   = "For RTMPS live streams"
  name          = "${google_compute_network.bitmovin_vpc_network.name}-rtmps-listener"
  network       = google_compute_network.bitmovin_vpc_network.name
  source_ranges = var.live_ingress_ipv4_network_blocks

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

resource "google_compute_firewall" "bitmovin_srt_listener" {
  count = var.live_srt ? 1 : 0

  description   = "For SRT live streams"
  name          = "${google_compute_network.bitmovin_vpc_network.name}-srt-listener"
  network       = google_compute_network.bitmovin_vpc_network.name
  source_ranges = var.live_ingress_ipv4_network_blocks

  allow {
    protocol = "tcp"
    ports    = ["2088"]
  }

  allow {
    protocol = "udp"
    ports    = ["2088", "2089", "2090", "2091"]
  }
}

resource "google_compute_firewall" "bitmovin_zixi_listener" {
  count = var.live_zixi ? 1 : 0

  description   = "For Zixi live streams"
  name          = "${google_compute_network.bitmovin_vpc_network.name}-zixi-listener"
  network       = google_compute_network.bitmovin_vpc_network.name
  source_ranges = var.live_ingress_ipv4_network_blocks

  allow {
    protocol = "tcp"
    ports    = ["4444"]
  }
}
