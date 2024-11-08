output "container_app_environment_id" {
  description = "The ID of the Container App Environment"
  sensitive   = false
  value       = try(azurerm_container_app_environment.this.id)
}
output "container_app_environment_default_domain" {
  description = "he default, publicly resolvable, name of this Container App Environment.   "
  sensitive   = false
  value       = try(azurerm_container_app_environment.this.default_domain)
}
output "container_app_environment_docker_bridge_cidr" {
  description = "The network addressing in which the Container Apps in this Container App Environment will reside in CIDR notation."
  sensitive   = false
  value       = try(azurerm_container_app_environment.this.docker_bridge_cidr)
}
output "container_app_environment_platform_reserved_cidr" {
  description = "The IP range, in CIDR notation, that is reserved for environment infrastructure IP addresses."
  sensitive   = false
  value       = try(azurerm_container_app_environment.this.platform_reserved_cidr)
}
output "container_app_environment_platform_reserved_dns_ip_address" {
  description = "The IP address from the IP range defined by `platform_reserved_cidr` that is reserved for the internal DNS server."
  sensitive   = false
  value       = try(azurerm_container_app_environment.this.platform_reserved_dns_ip_address)
}
output "container_app_environment_static_ip_address" {
  description = "The Static IP of the Environment."
  sensitive   = false
  value       = try(azurerm_container_app_environment.this.static_ip_address)
}

