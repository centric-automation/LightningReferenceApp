resource "azurerm_sql_server" "dbserver" {
  name                         = "${var.application_name}-dbserver-${var.environment}"
  resource_group_name          = azurerm_resource_group.app.name
  location                     = var.region
  version                      = "12.0"
  administrator_login          = azurerm_key_vault_secret.DbLogin.value
  administrator_login_password = azurerm_key_vault_secret.DbPassword.value	
}

resource "azurerm_sql_firewall_rule" "allowServiceConnectionsRule" {
  name                = "FirewallRule-${var.environment}"
  resource_group_name = azurerm_resource_group.app.name
  server_name         = azurerm_sql_server.dbserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_database" "db" {
  name                = "${var.application_name}-db-${var.environment}"
  resource_group_name = azurerm_resource_group.app.name
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