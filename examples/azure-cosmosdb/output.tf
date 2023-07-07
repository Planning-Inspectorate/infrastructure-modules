/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}
output "cosmos_id" {
  description = "Cosmos ID"
  value       = azurerm_cosmosdb_account.db.id
}
output "cosmos_endpoint" {
  description = "Endpoint to connect to the CosmosDb account"
  value       = azurerm_cosmosdb_account.db.endpoint
}
output "cosmos_read_endpoints" {
  description = "Read endpoints"
  value       = azurerm_cosmosdb_account.db.read_endpoints
}
output "cosmos_write_endpoints" {
  description = "Write endpoints"
  value       = azurerm_cosmosdb_account.db.write_endpoints
}
output "cosmos_primary_master_key" {
  description = "Primary master key"
  value       = azurerm_cosmosdb_account.db.primary_master_key
  sensitive   = true
}
output "cosmos_secondary_master_key" {
  description = "Secondary master key"
  value       = azurerm_cosmosdb_account.db.secondary_master_key
  sensitive   = true
}
output "cosmos_primary_readonly_master_key" {
  description = "Primary read-only master key"
  value       = azurerm_cosmosdb_account.db.primary_readonly_master_key
  sensitive   = true
}
output "cosmos_secondary_readonly_master_key" {
  description = "Secondary read-only master key"
  value       = azurerm_cosmosdb_account.db.secondary_readonly_master_key
  sensitive   = true
}
output "cosmos_connection_strings" {
  description = "List of connection strings"
  value       = azurerm_cosmosdb_account.db.connection_strings
  sensitive   = true
}