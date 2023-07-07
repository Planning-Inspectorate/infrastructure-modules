/*
    Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_monitor_action_group" "ag" {
  resource_group_name = var.action_group_rg
  name                = var.action_group_name
}