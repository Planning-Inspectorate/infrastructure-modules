/*
    Terraform configuration file defining data elements
*/

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group_name
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

data "azurerm_key_vault_secret" "admin_password" {
  name         = "vm-admin-windows"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_recovery_services_vault" "vault" {
  name                = var.asr_vault_name
  resource_group_name = var.asr_vault_rg
}

