/*
    Terraform configuration file defining provider configuration
*/

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  subscription_id            = var.dns_zones_subscription_id
  skip_provider_registration = true
  alias                      = "platform"
}

terraform {
  backend "azurerm" {}
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2"
    }
  }
}