terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
       version = "3.104.0"
    }
  }
}
provider "azurerm" {
  features {}

}

resource "azurerm_resource_group" "TharunRG001" {
  name     = "TharunRG"
  location = "West Europe"
}

