/*
    Terraform configuration file defining data elements
*/

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

data "azurerm_key_vault_secret" "ad_sql_service_account_password" {
  name         = "svc-${var.environment}-${var.application}-tfsql"
  key_vault_id = data.azurerm_key_vault.kv.id
}