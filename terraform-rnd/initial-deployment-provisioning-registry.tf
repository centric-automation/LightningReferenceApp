resource "azurerm_resource_group" "devrg" {
  name     = var.dev_resource_group_name
  location = var.dev_resource_region
}

resource "azurerm_container_registry" "acr" {
  name                     = var.dev_container_registry_name
  resource_group_name      = azurerm_resource_group.devrg.name
  location                 = azurerm_resource_group.devrg.location
  sku                      = "Basic"
  admin_enabled            = false
  # georeplication_locations = ["East US"]	
}

output "login_server" {
  value = azurerm_container_registry.acr.login_server
}
