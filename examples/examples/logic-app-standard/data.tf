/*
    Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_log_analytics_workspace" "law" {
  name                = var.law_name
  resource_group_name = var.law_resource_group_name
}