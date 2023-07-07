/*
	Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_storage_account" "sa" {
  name                = var.storage_account_name
  resource_group_name = var.storage_account_rg
}

