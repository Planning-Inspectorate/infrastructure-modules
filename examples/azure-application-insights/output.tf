/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "id" {
  description = "The ID of the Insights"
  value       = azurerm_application_insights.ai.id
}

output "instrumentation_key" {
  sensitive   = true
  description = "The instrumentation key of the Insights"
  value       = azurerm_application_insights.ai.instrumentation_key
}

output "connection_string" {
  sensitive   = true
  description = "The connection string of the Insights"
  value       = azurerm_application_insights.ai.connection_string
}