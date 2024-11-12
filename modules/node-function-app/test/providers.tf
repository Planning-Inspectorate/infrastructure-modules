terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.9.0"
    }
    # random = {
    #   source  = "hashicorp/random"
    #   version = "~>3.1"
    # }
    # time = {
    #   source  = "hashicorp/time"
    #   version = "~>0.9"
    # }
  }
  required_version = ">= 1.5.7, < 1.10.0"
}

provider "azurerm" {
  features {}
}
