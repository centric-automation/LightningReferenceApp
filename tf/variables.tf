#Administrative
variable "state_resource_group_name" {
	default="apptfstate"
}
variable "state_storage_account_name" {
	default="apptfstate31538"
}
variable "state_container_name" {
	default="apptfstate"
}
variable "state_key" {
	default="mJYySEkR4Q9BvyoLKdZioVlyR9Jic74HZPKJgpkMazH3uhzM/T2YNoW00m79TvWmxgiS4DuqeDIf9d/RsaS/fw=="
}

# Development Shared
variable "shared_resource_group_name" {}
variable "shared_container_registry_name" {}
variable "shared_container_registry_login_server" {}
variable "shared_container_registry_admin_username" {}
variable "shared_container_registry_admin_password" {}

# Application
variable "application_name" { }
variable "environment" { }
variable "region" { }  
variable "api_size" { }
variable "api_tier" { }