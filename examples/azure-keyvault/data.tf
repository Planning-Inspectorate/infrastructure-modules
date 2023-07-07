/*
	Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azuread_group" "groups" {
  count        = length(local.group_names)
  display_name = local.group_names[count.index]
}

data "azuread_user" "users" {
  count               = length(local.user_principal_names)
  user_principal_name = local.user_principal_names[count.index]
}

data "azurerm_resource_group" "rg" {
  name       = var.resource_group_name == "" ? azurerm_resource_group.rg[0].name : var.resource_group_name
  depends_on = [azurerm_resource_group.rg]
}

data "azurerm_client_config" "current" {
}