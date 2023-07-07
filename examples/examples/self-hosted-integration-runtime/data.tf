/*
    Terraform configuration file defining data elements
*/

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_resource_group_name
}

data "azurerm_key_vault" "kv" {
  name                = var.shir_key_vault_name
  resource_group_name = var.shir_key_vault_resource_group_name
}