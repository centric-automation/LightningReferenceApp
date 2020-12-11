resource "azurerm_storage_account" "web" {
  name                     = "${random_pet.server.id}web${var.environment}"
  resource_group_name      = azurerm_resource_group.app.name
  location                 = azurerm_resource_group.app.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
	allow_blob_public_access = true

	static_website {
		index_document = "index.html"
	}	
}

output "web_app_url" {
  description = "WEB APP URL"
  value       = azurerm_storage_account.web.primary_web_endpoint
}