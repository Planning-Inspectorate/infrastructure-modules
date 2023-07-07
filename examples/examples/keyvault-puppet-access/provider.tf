/*
    Terraform configuration file defining provider configuration
*/

provider "azurerm" {
  features {}
}

provider "azurerm" {
  # Setting version
  # See https://www.terraform.io/docs/configuration/providers.html
  #version = "~> 2" # any non-beta version >= 1.21.0 and < 2.0.0, e.g. 1.x.y
  features {}
  subscription_id            = var.platform_subscription_id
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