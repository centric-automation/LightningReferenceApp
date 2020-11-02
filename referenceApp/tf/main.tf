provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.20.0"
  features {}
}

terraform {
	backend "azurerm" {
		resource_group_name   = var.state_resource_group_name
    storage_account_name  = var.state_storage_account_name
    container_name          = var.state_container_name
    key                        = var.state_key
	}
}