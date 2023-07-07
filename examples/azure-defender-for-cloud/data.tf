/*
	Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}