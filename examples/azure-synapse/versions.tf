terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2, < 3"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 1.4, < 2"
    }
    time = {
      source = "hashicorp/time"
      version = ">=0.7, < 1"
    }
  }
}