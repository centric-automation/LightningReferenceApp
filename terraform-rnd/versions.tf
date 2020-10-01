terraform {
  required_providers {
    azuredevops = {
      source = "terraform-providers/azuredevops"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  required_version = ">= 0.13"
}
