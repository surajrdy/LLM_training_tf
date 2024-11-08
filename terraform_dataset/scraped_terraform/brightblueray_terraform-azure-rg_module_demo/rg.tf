# terraform {
#   required_providers {
#     random = {
#       source = "hashicorp/random"
#       version = "3.4.3"
#     }
#   }
# }

# provider "random" {
#   # Configuration options
# }

resource "random_id" "rg_name" {
  byte_length = 8
  prefix = var.prefix
}

resource "azurerm_resource_group" "rg" {
  name     = "${random_id.rg_name.id}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${random_id.rg_name.id}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "intsubnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "sg" {
  name                = "${random_id.rg_name.id}-sg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}