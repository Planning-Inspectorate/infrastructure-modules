terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 3.0, < 5.0"
      configuration_aliases = [azurerm, azurerm.tooling]
    }
  }
}

provider "azurerm" {
  alias = "tooling"

  features {}
}