resource "azurerm_key_vault" "kv" {
  name                = "${var.application_name}vault${var.environment}"
  resource_group_name = azurerm_resource_group.app.name
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

resource "azurerm_key_vault_secret" "DbLogin" {
  name         = "dbLogin"
  value        = random_string.random.result
  key_vault_id = azurerm_key_vault.kv.id

  tags = {
    environment = var.environment
  }
}

resource "azurerm_key_vault_secret" "DbPassword" {
  name         = "dbPassword"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.kv.id

  tags = {
    environment = var.environment
  }
}
