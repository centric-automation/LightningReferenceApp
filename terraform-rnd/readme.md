# Use Terraform to Provision a Microsoft DevOps Team

Using the Terraform scripts provided here, the user should be able to create a new Project and certain other necessary Azure required for the team to begin building software.

A functional understanding of Terraform is required. Reference the [Appendix](#appendix) for any foundational or details not provided below.

## Prerequisites
Before this automation can be executed 

* Create/Re-Use Microsoft Azure Subscription
* Create a Microsoft DevOps Organization - https://dev.azure.com
* Customize the App Dev Process for the Organization to be in line with Centric's Right Site approach
* Initialize the Terraform state power store (See [Init Environment](#init-environment) in [Appendix](#appendix))

## Create a TFVARS fils for the New Project

## Execute the Terraform Script

<hr />

## What is Created as Part of the Process

* a
* b
* c
* d
* e

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
[Store Terraform state in Azure Storage](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage)

**Initialize your local access to to ensure state is shared property**

```shell
export ARM_ACCESS_KEY=$(az keyvault secret show --name terraform-backend-key --vault-name myKeyVault --query value -o tsv)
```

**Configure Terraform to use state stored in blob storage**
```shell
terraform init
terraform apply
```

### Environment Variables to Set
* ARM_ACCESS_KEY
* AZDO_PERSONAL_ACCESS_TOKEN -> This is the Azure DevOps organization personal access token.
  * export AZDO_PERSONAL_ACCESS_TOKEN=544rrz7y4rdwnd2immvb6d2hxchxoxicao3ltausxgqtasvxusxa