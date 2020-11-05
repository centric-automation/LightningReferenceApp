resource "azurerm_app_service_plan" "api" {
  name                = "referenceApp-apisp-${var.environment}"
  location            = var.region
  resource_group_name = azurerm_resource_group.referenceApp.name
  kind                = "Linux"
	reserved = true

  sku {
    tier = var.api_tier
    size = var.api_size
  }
}
