resource "azurerm_resource_group" "referenceApp" {
	name = "referenceApp_${var.environment}"
	location = var.region
}