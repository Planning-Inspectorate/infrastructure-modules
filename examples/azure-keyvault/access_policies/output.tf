
output "keyvault_access_policy_write_ids" {
  description = "IDs of application access policy"
  value = "${azurerm_key_vault_access_policy.write_ids.*.id}"
}
