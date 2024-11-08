resource "azurerm_resource_group" "resource-group" {
  name     = var.resource_group_name
  location = var.azure_region
}