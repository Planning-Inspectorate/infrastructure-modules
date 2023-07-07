/*
    Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_subnet" "fw" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}
