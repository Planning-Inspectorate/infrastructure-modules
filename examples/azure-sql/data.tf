/*
	Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_resource_group" "rg" {
  name       = var.resource_group_name == "" ? azurerm_resource_group.rg[0].name : var.resource_group_name
  depends_on = [azurerm_resource_group.rg]
}

# Getting AzureRM provider configuration
data "azurerm_client_config" "current" {
}

# The following 2 data blocks are used to get the object id of either the specified AD user or group
data "azuread_user" "sql_admin_user" {
  count               = coalesce(var.ad_sql_service_account, "unset") == "unset" ? 0 : 1
  user_principal_name = var.ad_sql_service_account
}

data "azuread_group" "sql_admin_group" {
  count        = coalesce(var.ad_sql_service_account, "unset") == "unset" ? 1 : 0
  display_name = var.sql_admin_group
}

