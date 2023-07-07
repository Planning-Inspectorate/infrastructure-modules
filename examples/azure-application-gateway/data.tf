/*
    Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_resource_group" "rg" {
  name       = var.resource_group_name == "" ? azurerm_resource_group.rg[0].name : var.resource_group_name
  depends_on = [azurerm_resource_group.rg]
}

data "azurerm_subnet" "sn" {
  name                 = local.subnet_id_elements[10]
  virtual_network_name = local.subnet_id_elements[8]
  resource_group_name  = local.subnet_id_elements[4]
}