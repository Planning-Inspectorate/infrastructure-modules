data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

data "azurerm_key_vault_secret" "admin_password" {
  name         = "vm-admin-linux"
  key_vault_id = data.azurerm_key_vault.kv.id
}