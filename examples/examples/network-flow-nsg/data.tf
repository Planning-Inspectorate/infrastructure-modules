/*
    Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_network_watcher" "network_watcher" {
  name                = var.network_watcher_name
  resource_group_name = var.network_watcher_resource_group_name
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

data "azurerm_key_vault_secret" "admin_password" {
  name         = "vm-admin-linux"
  key_vault_id = data.azurerm_key_vault.kv.id
}
