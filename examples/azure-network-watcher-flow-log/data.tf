/*
	Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_log_analytics_workspace" "law" {
  count               = var.analytics ? 1 : 0
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name
}
