terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2, < 3"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.7, < 1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3, < 4"
    }
  }
}