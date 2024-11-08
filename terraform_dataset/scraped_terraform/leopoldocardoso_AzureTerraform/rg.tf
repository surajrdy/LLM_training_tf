# Deploy RG
resource "azurerm_resource_group" "RG" {
  name     = "rg-homolog-001"
  location = "northcentralus"

  tags = {
    Environment = "IAC TERRAFORM"
  }
}