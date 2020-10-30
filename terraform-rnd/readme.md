# Use Terraform to Provision a Microsoft DevOps Team

Using the Terraform scripts provided here, the user should be able to create a new Microsoft Azure DevOps Project as well as other necessary Azure resources required for the team to begin the project.

A functional understanding of Microsoft Azure Administration and Terraform are required. Reference the [Appendix](#appendix) for any foundational information or details not provided below.

## Prerequisites
Before this automation can be executed that initializes the team, there are required actions that must be first met.

1. **Create/Re-Use Microsoft Azure Subscription**

	> Visit the [Microsoft Azure Portal](https://portal.azure.com) and ensure the client has a Microsoft Azure subscription created with billing details specified.
	>
	> *NOTE: an existing subscription can be used or a new one may be created.*
	> 
	> Make note of the subscription name for later use.

2. **Create a Microsoft DevOps Organization**
	> Execute the steps to create a new Microsoft Azure DevOps Subscription on the [Microsoft Azure DevOps](https://dev.azure.com) site. Use the subscriiption identified in the previous step. Take note of the newly created Organization URL.
	>
	> Ensure that the team member executing the Terraform scripts has ***Administrative*** level access to the Organization.

3.  **Customize the App Dev Process Template for the Organization to be consistent with Centric's Right Site approach**

	> A key component of Centric's Right Site model is a Microsoft Azure DevOps [Customized Process Template](https://docs.microsoft.com/en-us/azure/devops/organizations/settings/work/manage-process?view=azure-devops). Create an inherited process derived from the existing Agile Template. Name the process and **remember the name** to be used later in the process.
	>
	> Modify this process according the the current Right Site process guidelines.

4. **Initialize Terraform state shared storage**
	> The terraform scripts must be able to be used by multiple team members concurrently. As a result, the Terraform state should be shared. Follow the directions in the [Init Environment](#init-environment) section of the [Appendix](#appendix).

## Create the New Azure DevOps Project
Once all the prerequisites have been met, the following tasks can be performed to create a new Microsoft Azure DevOps ***Team*** in the created **Organization** contained in the ***Subscription***.

### Create a TFVARS fils for the New Project
The provisioning process is customized by supplying input values specific to this new project to be created. All of these input variables (and their defaults) are defined in the ```variables.tf``` file. 

The ```terraform.tfvars``` file can be used to set these values prior to script execution.

> Terraform will prompt for any values not specified in a ```.tfvars``` file.

The variables/input values consumed by this system are defined below

* project_organization_url: The base URL of the Microsoft Azure DevOps Organization. Example: `https://dev.azure.com/ModernSoftwareDelivery/`
* **project_name**: The name of the new Team to be created
* **project_description**: Detailed description of the Team to be creted
* **project_template**: The process template that the team should follow. This should be the name of the process template created in the prerequisites.
* **dev_resource_region**: The ```Azure Region``` in which new Azure resources should be provisioned. It should be a standard Azure Region. The Azure CLI can be used to determine valid regions. Execute the following Azure CLI command to determine valid regions: ```az account list-locations -o table```. Use the name value as the region name.
* **dev_resource_group_name**: The name of the ```Resource Group``` to be created to contain Azure development resources.
* **dev_container_registry_name**: The name of the ```Azure Container Registry``` to be created to host any Docker containers built and pushed through the CI/CD process.

### Execute the Terraform Script

To execute the scripts and provision the new Team and additional Azure resources, follow the standard Terraform process of executing the ```terraform plan``` and ```terraform apply``` commands.

```
terraform plan
terraform apply
```

At this point any manual customizations can be applied to the project.

<hr />

### What is Created as Part of the Process

| Resource | Defined in File |
|:-------|:-----------|
|Azure DevOps Project| ```azure-devops-organization.tf``` |
|Git Repository| ```azure-devops-organization.tf``` |
|Azure Resource Group for Development resources| ```initial-deployment-provisioning-registry.tf``` |
|Azure Container Registry| ```initial-deployment-provisioning-registry.tf``` |

<hr />

## Appendix

### Terraform Foundations
* [Getting Started](https://azure.microsoft.com/en-us/solutions/devops/terraform/)
* [Commands](https://www.terraform.io/docs/commands/index.html)
* [Azure Provider](https://www.terraform.io/docs/providers/azurerm/)
* [Azure DevOps Provider](https://www.terraform.io/docs/providers/azuredevops/index.html)
* [Store Terraform state in Azure Storage](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage)
* [Further Reading: Documentation Root](https://docs.microsoft.com/en-us/azure/developer/terraform/)

### Init Environment
The information used to accomplish this step comes from the blog post [Store Terraform state in Azure Storage](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage) from Microsoft.

If a shell script is being used in Windows, MacOS, or Linux the script ```init_cloud_state_storage.sh``` can be customzed to implement these steps.

If powershell is being used to execute these steps, the appropriate az cli steps can be executed to perform the correct tasks.

To execute the Terraform scripts, the following environment variables must be set to ensure proper credentials are used during execution:

* **ARM_ACCESS_KEY**: Access key used to access the shared state storage location. Customize the following command and execute to set.
	``` shell
	export ARM_ACCESS_KEY=$(az keyvault secret show --name terraform-backend-key --vault-name <myKeyVault> --query value -o tsv)
	```
* **AZDO_PERSONAL_ACCESS_TOKEN**: This is the Azure DevOps organization personal access token. Customize the following command and execute to set.
	```shell
	export AZDO_PERSONAL_ACCESS_TOKEN=<yourPersonalAccessToken>
	```


#### Configure Terraform to use state stored in blob storage
```shell
terraform init
terraform apply
```
