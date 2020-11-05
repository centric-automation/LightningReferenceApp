resource "azurerm_app_service" "api" {
  name                = "${random_pet.server.id}-api-${var.environment}"
  location            = azurerm_resource_group.referenceApp.location
  resource_group_name = azurerm_resource_group.referenceApp.name
  app_service_plan_id = azurerm_app_service_plan.api.id

  site_config {
		always_on = false
		    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/referenceapp.api:latest"
	}
	
	app_settings = {
    "MSDEPLOY_RENAME_LOCKED_FILES" = "1"
		"WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
		"DOCKER_REGISTRY_SERVER_URL"          = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"     = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = azurerm_container_registry.acr.admin_password
		# "ConnectionStrings_ReferenceAppConnectionString" = "Server=tcp:${azurerm_sql_server.dbserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.db.name};Persist Security Info=False;User ID=${azurerm_sql_server.dbserver.administrator_login};Password=${azurerm_sql_server.dbserver.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  connection_string {
    name  = "ReferenceAppConnectionString"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_sql_server.dbserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.db.name};Persist Security Info=False;User ID=${azurerm_sql_server.dbserver.administrator_login};Password=${azurerm_sql_server.dbserver.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}