/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "analysis_services_server_id" {
  description = "The ID of the Analysis Services Server"
  value       = azurerm_analysis_services_server.analysis_services_server.id
}

output "analysis_services_server_name" {
  description = "The full name of the Analysis Services Server"
  value       = azurerm_analysis_services_server.analysis_services_server.server_full_name
}