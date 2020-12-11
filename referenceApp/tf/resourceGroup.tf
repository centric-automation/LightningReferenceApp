resource "azurerm_resource_group" "app" {
  name     = "${var.application_name}_${var.environment}"
  location = var.region
}

# resource "azurerm_resource_group" "sharedrg" {
#   name     = var.shared_resource_group_name
#   location = var.region
# }
