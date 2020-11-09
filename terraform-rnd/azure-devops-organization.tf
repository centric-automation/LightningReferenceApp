resource "azuredevops_project" "project" {
  project_name       = var.project_name
  description        = var.project_template
	visibility = "private"
	version_control = "Git"
	work_item_template = var.project_template

	features = {
		boards = "enabled"
		repositories = "enabled"
		pipelines = "enabled"
		testplans = "disabled"
		artifacts = "enabled"
	}
}



output "new_project_id" {
	description = "Project Id for the new project created"
	value = azuredevops_project.project.id
}

