resource "azurerm_storage_account" "this" {
  count = (length(var.resource_group) || var.resource_group_name != null) == 0 ? 0 : length(var.storage_account)
  account_replication_type = lookup(var.storage_account[count.index], "account_replication_type")
  account_tier             = lookup(var.storage_account[count.index], "account_tier")
  location                 = try(
    var.resource_group_name != null ? data.azurerm_resource_group.this.location : element(
      data.azurerm_resource_group.this.location, lookup(var.storage_account[count.index], "resource_group_id")
    )
  )
  name                     = lookup(var.storage_account[count.index], "name")
  resource_group_name      = try(
    var.resource_group_name != null ? data.azurerm_resource_group.this.name : element(
      azurerm_resource_group.this.*.name, lookup(var.storage_account[count.index], "resource_group_id")
    )
  )
}

resource "azurerm_storage_container" "this" {
  count = (length(var.storage_account) || var.storage_account_name != null) == 0 ? 0 : length(var.storage_container)
  name                 = lookup(var.storage_container[count.index], "name")
  storage_account_name = try(
    var.storage_account_name != null ? data.azurerm_storage_account.this.name : element(
      azurerm_storage_account.this.*.name, lookup(var.storage_container[count.index], "storage_account_id")
    )
  )
}