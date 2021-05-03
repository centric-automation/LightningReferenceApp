# This terraform.tfvars file is generic in order to portray what could be needed to deploy the Azure resources. 
# Using specific .tfvars files for each environment is the proprer way to reuse code while specifying differences in the resource builds
# Shared information #
shared_resource_group_name               = "appSharedRG"
shared_container_registry_name           = "appSharedCR"
shared_container_registry_login_server   = "appsharedcr.azurecr.io"
shared_container_registry_admin_username = "appSharedCR"
shared_container_registry_admin_password = "czSFT=uQlGcmyCj/xFh+Bk475Btg7j7S"


# New addition to tfvars #
environment      = "dev" 
region           = "eastus2"
application_name = "app123"