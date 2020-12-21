resource "azurerm_application_insights" "insights" {
  name                = "${random_pet.server.id}-appinsights-${var.environment}"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  application_type    = "web"
}

output "instrumentation_key" {
  value = azurerm_application_insights.insights.instrumentation_key
}

output "app_id" {
  value = azurerm_application_insights.insights.app_id
}

resource "azurerm_monitor_action_group" "performance_alert" {
  name = "PerformanceAlert"
  resource_group_name = azurerm_resource_group.app.name
  short_name = "perfAlert"
}
