/*
	Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_resource_group" "rg" {
  name       = var.resource_group_name == "" ? azurerm_resource_group.rg[0].name : var.resource_group_name
  depends_on = [azurerm_resource_group.rg]
}

resource "random_string" "rnd" {
  length  = 4
  special = false
  upper   = false
  number  = false
}