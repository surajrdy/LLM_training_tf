resource "azurerm_public_ip" "vnet-1-ip" {
  name                = "VNET-1-ip"
  location            = azurerm_resource_group.resource-group-1.location
  resource_group_name = azurerm_resource_group.resource-group-1.name
  allocation_method   = "Dynamic"
}
resource "azurerm_public_ip" "vnet-2-ip" {
  name                = "VNET-2-ip"
  location            = azurerm_resource_group.resource-group-2.location
  resource_group_name = azurerm_resource_group.resource-group-2.name
  allocation_method   = "Dynamic"
}
resource "azurerm_public_ip" "vhub-ip" {
  name                = "vhub-ip"
  location            = azurerm_resource_group.vhub.location
  resource_group_name = azurerm_resource_group.vhub.name
  allocation_method   = "Dynamic"
}
resource "azurerm_public_ip" "vm-1-ip" {
  name                = "vm-1-ip"
  location            = azurerm_resource_group.resource-group-1.location
  resource_group_name = azurerm_resource_group.resource-group-1.name
  allocation_method   = "Dynamic"
}