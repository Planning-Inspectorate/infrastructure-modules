/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "route_table_id" {
  description = "ID of the route table"
  value       = azurerm_route_table.rt.id
}
