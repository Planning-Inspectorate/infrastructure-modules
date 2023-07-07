/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "databricks_workspace_id" {
  description = "The ID of the Databricks Workspace"
  value       = azurerm_databricks_workspace.azurerm_databricks_workspace.id
}