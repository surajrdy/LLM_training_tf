output "vm-network-internal-ip" {
  value = google_compute_instance.super-natural.network_interface[0].network_ip
}

output "vm-network-external-ip" {
  value = google_compute_instance.super-natural.network_interface[0].access_config[0].nat_ip
}
