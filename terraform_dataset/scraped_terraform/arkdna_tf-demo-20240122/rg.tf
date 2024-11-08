resource "azurerm_resource_group" "myfirstrg" {
  for_each = var.customers

  name     = "${each.key}${terraform.workspace}_rg"
  location = each.value.location

  tags = merge( var.tags, { "env": "testing"} )
}