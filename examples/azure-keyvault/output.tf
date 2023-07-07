/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "keyvault_uri" {
  description = "Vaults uri"
  value       = azurerm_key_vault.key_vault.vault_uri
}

output "keyvault_id" {
  description = "Vault ID"
  value       = azurerm_key_vault.key_vault.id
}

output "keyvault_name" {
  description = "Vault name"
  value       = azurerm_key_vault.key_vault.name
}

output "location" {
  description = "Vault location"
  value       = azurerm_key_vault.key_vault.location
}

# output "keyvault_access_policy_write_ids" {
#   description = "ID of application access policy"
#   value = module.access_policies.keyvault_access_policy_write_ids
# }

# // ID of SP access policy
# output "azure_sp_access_policy_id" {
#     value = "${azurerm_key_vault_access_policy.azure_sp.id}"
# }
