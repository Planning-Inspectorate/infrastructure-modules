/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "synapse_dlg2fs_id" {
  description = "ID of the Synapse dlg2fs"
  value       = azurerm_storage_data_lake_gen2_filesystem.storage_dlg2fs_synapse.id
}

output "synapse_id" {
  description = "ID of the Synapse workspace"
  value       = azurerm_synapse_workspace.syw.id
}

output "connectivity_endpoints" {
  description = "A list of Connectivity endpoints for this Synapse Workspace"
  value       = azurerm_synapse_workspace.syw.connectivity_endpoints
}

output "aad_admin" {
  description = "Name of Azure Active Directory Admin"
  value       = local.aad_admin
}

output "sql_admin_login" {
  description = "Name of the SQL administrator login"
  value       = "${var.environment}${var.application}sqladmin"
}

output "sqlpools" {
  description = "Map of sqlpools"
  value       = azurerm_synapse_sql_pool.sqlpools
}