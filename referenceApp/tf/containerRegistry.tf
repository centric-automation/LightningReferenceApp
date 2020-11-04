resource "azurerm_resource_group" "sharedrg" {
  name     = var.shared_resource_group_name
  location = var.region
}

resource "azurerm_container_registry" "acr" {
  name                     = var.shared_container_registry_name
  resource_group_name      = azurerm_resource_group.sharedrg.name
  location                 = azurerm_resource_group.sharedrg.location
  sku                      = "Basic"
  admin_enabled            = false
  # georeplication_locations = ["East US"]	
}

output "login_server" {
  value = azurerm_container_registry.acr.login_server
}