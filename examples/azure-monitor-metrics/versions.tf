terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2, < 3"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2, < 3"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2, < 3"
    }
  }
}