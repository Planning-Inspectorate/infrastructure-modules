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
    random = {
      source  = "hashicorp/random"
      version = ">= 3, < 4"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.7, < 1"
    }
    mssql = {
      source = "betr-io/mssql"
      version = "0.2.4"
    }
  }
}