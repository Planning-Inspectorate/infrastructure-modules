/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "private_endpoint" {
  description = "The details of the created private endpoint resource"
  value       = azurerm_private_endpoint.pe
}

# output "subresource_provider" {
#   value = lookup(local.subresource_names, join("/", [local.provider_name, local.resource_provider_type]), [])
# }


# output "resource_array" {
#   value = split("/", var.private_connection_resource_id)
# }