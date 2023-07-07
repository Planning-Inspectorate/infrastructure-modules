/*
    Terraform configuration file defining data elements
*/

resource "time_static" "t" {}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

data "azurerm_key_vault_secret" "infoblox_password" {
  name         = "infoblox-svcinfobloxazureint"
  key_vault_id = data.azurerm_key_vault.kv.id
}