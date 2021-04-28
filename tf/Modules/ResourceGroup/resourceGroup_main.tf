resource "azurerm_resource_group" "app" {
  name     = var.rg_name #"${var.application_name}_${var.environment}"
  location = var.region
}
output "rg_name" {
  value    = azurerm_resource_group.app.name
}

output "rg_location" {
  value    = azurerm_resource_group.app.location
}
# resource "azurerm_resource_group" "sharedrg" {
#   name     = var.shared_resource_group_name
#   location = var.region
# }
