

# Init Environment

[Store Terraform state in Azure Storage](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage)

**Initialize your local access to to ensure state is shared properly**

```shell
export ARM_ACCESS_KEY=$(az keyvault secret show --name terraform-backend-key --vault-name myKeyVault --query value -o tsv)
```

**Configure Terraform to use state stored in blob storage**
```shell
terraform init
terraform apply
```




### Environment Variables
* ARM_ACCESS_KEY
* AZDO_PERSONAL_ACCESS_TOKEN -> This is the Azure DevOps organization personal access token.