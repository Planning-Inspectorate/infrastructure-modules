/*
	Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_resource_group" "rg" {
  name       = var.resource_group_name == "" ? azurerm_resource_group.rg[0].name : var.resource_group_name
  depends_on = [azurerm_resource_group.rg]
}

data "azurerm_client_config" "current" {
}

data "azuread_user" "aad_admin_user" {
  count               = var.aad_admin_user == "" ? 0 : 1
  user_principal_name = var.aad_admin_user
}

data "azuread_group" "aad_admin_group" {
  count        = var.aad_admin_group == "" ? 0 : 1
  display_name = var.aad_admin_group
}