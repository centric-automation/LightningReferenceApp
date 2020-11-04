resource "azurerm_key_vault" "kv" {
  name                = "referenceAppvault${var.environment}"
  resource_group_name = azurerm_resource_group.referenceApp.name
  location            = var.region
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

	access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
    ]
  }

	tags = {
    environment = var.environment
  }
}

resource "azurerm_key_vault_secret" "referenceAppDbLogin" {
  name         = "dbLogin"
  value        = random_string.random.result
  key_vault_id = azurerm_key_vault.kv.id

  tags = {
    environment = var.environment
  }
}

resource "azurerm_key_vault_secret" "referenceAppDbPassword" {
  name         = "dbPassword"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.kv.id

  tags = {
    environment = var.environment
  }
}
