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
    time = {
      source  = "hashicorp/time"
      version = "~>0.7"
    }
    infoblox = {
      source  = "infobloxopen/infoblox"
      version = "2.0.1"
    }
  }
}

provider "infoblox" {
  username = var.infoblox_user
  password = sensitive(data.azurerm_key_vault_secret.infoblox_password.value)
  server   = var.infoblox_server
}