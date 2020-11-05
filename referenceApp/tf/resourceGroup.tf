resource "azurerm_resource_group" "referenceApp" {
	name = "referenceApp_${var.environment}"
	location = var.region
}

resource "azurerm_resource_group" "sharedrg" {
  name     = var.shared_resource_group_name
  location = var.region
}