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

resource "azuredevops_git_repository" "repo" {
	project_id = azuredevops_project.project.id
	name = "the code"
	initialization {
		#init_type = "Import"
		init_type = "Clean"
		# source_type = "git"
		# source_url = "https://ModernSoftwareDelivery@dev.azure.com/ModernSoftwareDelivery/LightningDevOps/_git/LightningDevOps"
	}
}

output "new_project_id" {
	description = "Project Id for the new project created"
	value = azuredevops_project.project.id
}

output "clone_url" {
	description = "SSH URL to clone code"
	value = azuredevops_git_repository.repo.ssh_url
}