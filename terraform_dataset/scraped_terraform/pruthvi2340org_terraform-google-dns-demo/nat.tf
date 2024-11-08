resource "google_compute_router_nat" "vpc-1-nat" {
  name                               = "${var.name}-nat-vpc-1"
  router                             = google_compute_router.vpc-1.name
  region                             = var.region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
  min_ports_per_vm                   = 32
  max_ports_per_vm                   = 64
}

resource "google_compute_router_nat" "vpc-2-nat" {
  name                               = "${var.name}-nat-vpc-2"
  router                             = google_compute_router.vpc-2-peering.name
  region                             = var.region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
  min_ports_per_vm                   = 32
  max_ports_per_vm                   = 64
}

resource "google_compute_router_nat" "vpn-nat" {
  name                               = "${var.name}-nat-vpn"
  router                             = google_compute_router.vpn-to-vpc-1.name
  region                             = var.region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
  min_ports_per_vm                   = 32
  max_ports_per_vm                   = 64
}


resource "google_compute_router_nat" "other-org-nat" {
  provider                           = google.other-org
  name                               = "${var.name}-nat-other-org"
  router                             = google_compute_router.other-org-router.name
  region                             = var.region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
  min_ports_per_vm                   = 32
  max_ports_per_vm                   = 64
}