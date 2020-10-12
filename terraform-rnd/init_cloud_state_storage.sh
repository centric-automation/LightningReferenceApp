#!/bin/bash

RESOURCE_GROUP_NAME=tstate
STORAGE_ACCOUNT_NAME=tstate$RANDOM
CONTAINER_NAME=tstate
VAULT_NAME=tstatevault$RANDOM

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

# store storage key in keyvault
az keyvault create --name $VAULT_NAME --resource-group $RESOURCE_GROUP_NAME --location eastus
az keyvault secret set --vault-name $VAULT_NAME --name "AccessKey" --value $ACCOUNT_KEY
export ARM_ACCESS_KEY=$(az keyvault secret show --name AccessKey --vault-name $VAULT_NAME --query value -o tsv)

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"