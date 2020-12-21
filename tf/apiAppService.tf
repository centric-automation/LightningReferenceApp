resource "azurerm_app_service" "api" {
  name                = "${random_pet.server.id}-api-${var.environment}"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  app_service_plan_id = azurerm_app_service_plan.api.id

  site_config {
		always_on = false
		linux_fx_version = "DOCKER|${var.shared_container_registry_login_server}/${var.application_name}.api:latest"
	}
	
	app_settings = {
    "MSDEPLOY_RENAME_LOCKED_FILES" = "1"
		"WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
		"DOCKER_REGISTRY_SERVER_URL"          = "https://${var.shared_container_registry_login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"     = var.shared_container_registry_admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = var.shared_container_registry_admin_password
		"DOCKER_CUSTOM_IMAGE_NAME" = "${var.shared_container_registry_login_server}/refrenceApp.api:latest"
		"ApplicationInsights__ApplicationVersion" = "${var.shared_container_registry_login_server}/refrenceApp.api:latest"
		"APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.insights.instrumentation_key
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

output "api_url" {
  description = "API URL"
  value       = azurerm_app_service.api.default_site_hostname
}

resource "azurerm_application_insights_web_test" "api" {
  name = "api"
  location = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  application_insights_id = azurerm_application_insights.insights.id
  kind = "ping"
  frequency = 300
  timeout = 60
  description = "Check to make sure API is available"
  geo_locations = [
    "us-va-ash-azr",
    "us-ca-sjc-azr",
    "us-fl-mia-edge",
    "us-il-ch1-azr",
    "us-tx-sn1-azr"
  ]

  configuration = <<XML
<WebTest Name="api" Id="ABD48585-0831-40CB-9069-682EA6BB3583" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="0" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description="" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale="">
  <Items>
    <Request Method="GET" Guid="a5f10126-e4cd-570d-961c-cea43999a200" Version="1.1" Url="https://${azurerm_app_service.api.default_site_hostname}/api/Todo" ThinkTime="0" Timeout="300" ParseDependentRequests="True" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />
  </Items>
</WebTest>
XML
}

resource "azurerm_monitor_metric_alert" "api_failed_requests" {
  name = "apiFailedRequests"
  resource_group_name = azurerm_resource_group.app.name

  scopes = [azurerm_app_service.api.id]
  description = "Triggered when failed requests rise above background noise"

  criteria {
    metric_namespace = "microsoft.web/sites"
    metric_name = "Http5xx"
    aggregation = "Count"
    operator = "GreaterThanOrEqual"
    threshold = "3"
  }

  action {
    action_group_id = azurerm_monitor_action_group.performance_alert.id
  }
}

resource "azurerm_monitor_metric_alert" "api_response_time" {
  name = "apiResponseTime"
  resource_group_name = azurerm_resource_group.app.name

  scopes = [azurerm_app_service.api.id]
  description = "Triggered when response time rises above SLA"

  criteria {
    metric_namespace = "microsoft.web/sites"
    metric_name = "HttpResponseTime"
    aggregation = "Average"
    operator = "GreaterThanOrEqual"
    threshold = "0.5"
  }

  action {
    action_group_id = azurerm_monitor_action_group.performance_alert.id
  }
}

resource "azurerm_monitor_metric_alert" "api_pending_requests" {
  name = "apiPendingRequests"
  resource_group_name = azurerm_resource_group.app.name

  scopes = [azurerm_app_service.api.id]
  description = "Triggered when pending request count rises above SLA"

  criteria {
    metric_namespace = "microsoft.web/sites"
    metric_name = "RequestsInApplicationQueue"
    aggregation = "Average"
    operator = "GreaterThanOrEqual"
    threshold = "10"
  }

  action {
    action_group_id = azurerm_monitor_action_group.performance_alert.id
  }
}
