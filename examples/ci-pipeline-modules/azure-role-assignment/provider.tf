/*
    Terraform configuration file defining provider configuration
*/

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {}
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1"
    }
  }
}