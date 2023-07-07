/*
    Terraform configuration file defining provider configuration
*/

provider "azurerm" {
  # Setting version
  # See https://www.terraform.io/docs/configuration/providers.html
  #version = "~> 2" # any non-beta version >= 1.21.0 and < 2.0.0, e.g. 1.x.y
  features {}
}

provider "databricks" {
  # see https://github.com/databrickslabs/terraform-provider-databricks
  # If you use Terraform 0.12, please execute the following curl command in your shell:
  # curl https://raw.githubusercontent.com/databrickslabs/databricks-terraform/master/godownloader-databricks-provider.sh | bash -s -- -b $HOME/.terraform.d/plugins
  #azure_workspace_resource_id = azurerm_databricks_workspace.azurerm_databricks_workspace.id
  azure_workspace_resource_id = module.databricks.databricks_workspace_id
  azure_client_id             = data.azurerm_client_config.current.client_id
  azure_tenant_id             = data.azurerm_client_config.current.tenant_id
}

terraform {
  backend "azurerm" {}
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2"
    }
    databricks = {
      source  = "databrickslabs/databricks"
      version = "~> 0"
    }
  }
}