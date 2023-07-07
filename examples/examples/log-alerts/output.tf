/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = azurerm_resource_group.resource_group.name
}

output "alert_ids" {
  description = "List of IDs of the scheduled query alerts"
  value       = module.log_alerts.ids
}