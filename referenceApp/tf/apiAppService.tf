resource "azurerm_app_service" "api" {
  name                = "${random_pet.server.id}-api-${var.environment}"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  app_service_plan_id = azurerm_app_service_plan.api.id

  site_config {
		always_on = false
		linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.application_name}.api:latest"
	}
	
	app_settings = {
    "MSDEPLOY_RENAME_LOCKED_FILES" = "1"
		"WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
		"DOCKER_REGISTRY_SERVER_URL"          = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"     = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = azurerm_container_registry.acr.admin_password
  }

  connection_string {
    name  = "${var.application_name}ConnectionString"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_sql_server.dbserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.db.name};Persist Security Info=False;User ID=${azurerm_sql_server.dbserver.administrator_login};Password=${azurerm_sql_server.dbserver.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

	identity {
		type="SystemAssigned"
	}
}

resource "azurerm_app_service" "web" {
	name                = "${random_pet.server.id}-web-${var.environment}"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  app_service_plan_id = azurerm_app_service_plan.api.id

	site_config {
		always_on = false
		app_command_line = "yarn start"	
		default_documents = [
			"index.html"
		]
	}

	app_settings = {
		"REACT_APP_API_URL" = "https://${azurerm_app_service.api.default_site_hostname}/api"
	}
}

output "api_url" {
  description = "API URL"
  value       = azurerm_app_service.api.default_site_hostname
}

output "web_url" {
  description = "WEB URL"
  value       = azurerm_app_service.web.default_site_hostname
}