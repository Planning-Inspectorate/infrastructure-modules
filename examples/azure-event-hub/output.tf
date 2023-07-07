/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "namespace_id" {
  description = "The ID of the namespace"
  value       = azurerm_eventhub_namespace.ehn.id
}

output "namespace_name" {
  description = "The name of the namespace"
  value       = azurerm_eventhub_namespace.ehn.name
}

output "event_hub_ids" {
  description = "List of event hub IDs"
  value       = [for k, v in azurerm_eventhub.eh : v.id]
}