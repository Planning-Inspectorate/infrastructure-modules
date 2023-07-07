terraform {
  # required_version not set as this module should apply to all TF versions
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2, < 4"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.7, < 1"
    }
  }
}