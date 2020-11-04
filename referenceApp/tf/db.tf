resource "azurerm_sql_server" "dbserver" {
  name                         = "referenceapp-dbserver-${var.environment}"
  resource_group_name          = azurerm_resource_group.referenceApp.name
  location                     = var.region
  version                      = "12.0"
  administrator_login          = azurerm_key_vault_secret.referenceAppDbLogin.value
  administrator_login_password = azurerm_key_vault_secret.referenceAppDbPassword.value
}

resource "azurerm_sql_database" "db" {
  name                = "referenceapp-db-${var.environment}"
  resource_group_name = azurerm_resource_group.referenceApp.name
  location            = var.region
  server_name         = azurerm_sql_server.dbserver.name

  tags = {
    environment = var.environment
  }
}

output "connection_string" {
  description = "Connection string for the Azure SQL Database created."
  value       = "Server=tcp:${azurerm_sql_server.dbserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.db.name};Persist Security Info=False;User ID=${azurerm_sql_server.dbserver.administrator_login};Password=${azurerm_sql_server.dbserver.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}