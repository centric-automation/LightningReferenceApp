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