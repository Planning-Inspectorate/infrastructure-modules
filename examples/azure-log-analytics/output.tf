/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "workspace_id" {
  description = "The ID of the workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.id
}

output "workspace_name" {
  description = "The name of the workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.name
}

output "workspace_primary_key" {
  description = "Primary key of the workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.primary_shared_key
  sensitive   = true
}

output "workspace_secondary_key" {
  description = "Secondary key of the workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.secondary_shared_key
  sensitive   = true
}

output "workspace_customer_id" {
  description = "Customer ID of the workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.workspace_id
}

output "workspace_url" {
  description = "The portal URL of the workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.portal_url
}

output "location" {
  description = "The location of the resource"
  value       = azurerm_log_analytics_workspace.log_analytics.location
}