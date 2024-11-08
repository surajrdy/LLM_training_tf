data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "akv_svcfoundry" {
  count                       = var.create_kv == true ? 1 : 0
  name                        = "tfy-svcfoundry"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.svcfoundry.principal_id

    key_permissions = [
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "List",
      "Update"
    ]

    secret_permissions = [
      "Set",
      "Delete",
      "Get",
      "List"
    ]

    storage_permissions = [
      "Delete",
      "Get",
      "List",
      "Set",
      "Update"
    ]
  }
}
