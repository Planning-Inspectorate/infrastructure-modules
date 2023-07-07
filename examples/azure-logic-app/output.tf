/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "logicapp_ids" {
  description = "Logic app IDs"
  value       = azurerm_logic_app_workflow.logicapp.id
}

