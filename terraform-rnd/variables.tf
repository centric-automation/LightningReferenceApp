variable "resource_group_name" {
  default = "terraform-state-secure"
}

variable "region" {
  default = "eastus"
}

variable "project_organization_url" {
}

variable "project_name" {
  default = "New Project Name"
}

variable "project_description" {
  default = "New project description."
}

variable "project_template" {
}

# Development Team Initial Provisioned Values
variable "dev_resource_region" {
  default = "eastus"
}
variable "dev_resource_group_name" {}
variable "dev_container_registry_name" {}
