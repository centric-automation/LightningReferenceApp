resource "azuredevops_git_repository" "repo" {
	project_id = azuredevops_project.project.id
	name = "the code"
	initialization {
		# init_type = "Import"
		init_type = "Clean"
		# source_type = "git"
		# source_url = "https://ModernSoftwareDelivery@dev.azure.com/ModernSoftwareDelivery/LightningDevOps/_git/LightningDevOps"
	}
}

output "clone_url" {
	description = "SSH URL to clone code"
	value = azuredevops_git_repository.repo.ssh_url
}