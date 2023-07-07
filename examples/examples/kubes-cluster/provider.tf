provider "azurerm" {
  features {}
}

provider "azuread" {}

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
      version = "~> 1.4"
    }
    time = {
      source  = "hashicorp/time"
      version = "~>0.7"
    }
  }
}