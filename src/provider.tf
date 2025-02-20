terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azuredevops" {
  org_service_url = "https://dev.azure.com/${var.azure_devops_organization}"
  personal_access_token = var.azure_devops_pat
}

provider "azurerm" {
  features {}
  subscription_id = "Azure Subscription ID"
}