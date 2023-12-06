terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.5.7, < 3.74.0"
}

provider "azurerm" {
  features {}
}
