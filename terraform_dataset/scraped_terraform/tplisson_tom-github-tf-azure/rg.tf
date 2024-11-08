resource "azurerm_resource_group" "rg" {
  name     = "example5"
  location = "West Europe"
  tags = {
    owner     = "tplisson"
    yor_trace = "fafbf1c7-e393-4a5a-9fc7-5d4b29ec133d"
  }
}