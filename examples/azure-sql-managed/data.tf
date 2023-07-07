/*
	Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_resource_group" "rg" {
  name       = var.resource_group_name == "" ? azurerm_resource_group.rg[0].name : var.resource_group_name
  depends_on = [azurerm_resource_group.rg]
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.vnet_resource_group
  virtual_network_name = var.vnet_name
}