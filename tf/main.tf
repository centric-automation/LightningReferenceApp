provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~> 2.47.0"
  features {}
}

terraform {
	backend "azurerm" {
		resource_group_name   = "apptfstate"
    storage_account_name  = "apptfstate31538"
    container_name        = "!__apptfstate__!"
    
	}
}

resource "random_password" "password" {
  length  = 16
  special = true
  override_special = "_%@"
}

resource "random_string" "random" {
  length  = 16
  special = true
  override_special = "/@£$"
}

resource "random_pet" "server" {
	separator = ""
  keepers = {
    # Generate a new pet name each time we switch to a new AMI id
    environment = var.environment
  }
}

data "azurerm_client_config" "current" {
}

###########################################################################
# Module examples ~ Templates used to create all the modules listed below #
###########################################################################

# ~RESOURCE GROUP EXAMPLE~ #
module "resource_group" {
  source   = "./_Modules/ResourceGroup"
  rg_name  = "${var.application_name}_${var.environment}"
  region   = var.region #In every other module, you can specify this region variable or utilize the output variable produced from the Resource Group Module
}

# ~APP SERVICE PLAN EXAMPLE~ #
module "asp" {
  source   = "./_Modules/AppServicePlans" 
  resource_group_name   = module.resource_group.rg_name #References RG above to allow for resources creation of resources in this module
  app_service_plan_name = "${var.application_name}-apisp-${var.environment}"
  region                = module.resource_group.rg_location #var.region
  api_tier              = "Standard"
  api_size              = "S1" 

  depends_on  = [module.resource_group]
}

# ~APP INSIGHTS EXAMPLE~ #
module "appInsights" {
  source   = "./_Modules/AppInsights" 
  resource_group_name = module.resource_group.rg_name #References RG above to allow for resources creation of resources in this module
  app_insights_name   = "${random_pet.server.id}-appinsights-${var.environment}"

  depends_on  = [module.resource_group] 
}

# ~KEY VAULT EXAMPLE~ #
module "keyVault" {
  source   = "./_Modules/KeyVault" 
  resource_group_name        = module.resource_group.rg_name #References RG above to allow for resources creation of resources in this module
  key_vault_name             = "kv_name"
  environment                = var.environment
  region                     = var.region
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  object_id                  = data.azurerm_client_config.current.object_id
  keyVault_secret_dbLogin    = random_string.random.result
  keyVault_secret_dbPassword = random_password.password.result

  depends_on  = [module.resource_group]
}

# ~SQL DATABASE EXAMPLE~ #
module "db" {
  source   = "./_Modules/Database" 
  resource_group_name        = module.resource_group.rg_name #References RG above to allow for resources creation of resources in this module
  sql_server_name            = "${var.application_name}-dbserver-${var.environment}"
  sql_firewall_name          = "FirewallRule-${var.environment}"
  sql_db_name                = "${var.application_name}-db-${var.environment}"
  environment                = var.environment
  region                     = var.region
  keyVault_secret_dbLogin    = module.keyVault.key_vault_login_value
  keyVault_secret_dbPassword = module.keyVault.key_vault_login_password_value

  depends_on  = [module.resource_group, module.KeyVault]
}

# ~APP SERVICE EXAMPLE~ #
module "appservice" {
  source   = "./_Modules/AppService"
  resource_group_name                      = module.resource_group.rg_name
  app_service_plan_id                      = module.asp.app_service_plan_id #References ID defined in another module
  app_insights_key                         = module.appInsights.instrumentation_key
  app_service_name                         = "app-service-name"
  application_name                         = var.application_name
  connection_string                        = module.db.connection_string
  performance_alert_id                     = module.appInsights.monitor_action_group_performance_alert_id
  shared_container_registry_login_server   = var.shared_container_registry_login_server 
  shared_container_registry_admin_username = var.shared_container_registry_admin_username
  shared_container_registry_admin_password = var.shared_container_registry_admin_password

  depends_on  = [module.resource_group, module.db, module.asp, module.appInsights] #This module requires information from other Modules to properly run. Force organized deployments with Depends_on function
}

# ~WEB STORAGE ACCOUNT EXAMPLE~ #
module "web_storage_account" {
  source   = "./_Modules/WebStorageAccount"
  resource_group_name  = module.resource_group.rg_name
  web_storage_account_name = "${random_pet.server.id}web${var.environment}"

  depends_on  = [module.resource_group]
}