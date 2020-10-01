provider "azurerm" {
	version = "~>2.0"
	# Set ARM_ACCESS_KEY with key
  features {}
}

provider "azuredevops" {
	version = ">=0.0.1"
	org_service_url = var.project_organization_url
	# AZDO_PERSONAL_ACCESS_TOKEN with key
}

terraform {
	backend "azurerm" {
		resource_group_name   = "tstate"
    storage_account_name  = "tstate28493"
    container_name          = "tstate"
    key                        = "terraform.tfstate"
	}
}