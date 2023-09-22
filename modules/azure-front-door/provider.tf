terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.64.0"
    }
  }

  required_version = ">= 1.1.6, < 3.64.0"
}

provider "azurerm" {
  features {}
}
