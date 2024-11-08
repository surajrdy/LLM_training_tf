resource "azurerm_storage_account" "default" {
  name                            = "yourstorageaccountname" # replace me
  location                        = azurerm_resource_group.this.location
  resource_group_name             = azurerm_resource_group.this.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false

  # Required so the indexer can detect deleted files
  blob_properties {
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }
}

resource "azurerm_storage_container" "example" {
  name                 = "example"
  storage_account_name = azurerm_storage_account.default.name
}

data "azurerm_client_config" "current" {}

# permission for logged in user to upload to the storage account
resource "azurerm_role_assignment" "storage_blob_data_contributor_user" {
  principal_id = data.azurerm_client_config.current.object_id
  scope        = azurerm_storage_account.default.id

  role_definition_name = "Storage Blob Data Contributor"
}
