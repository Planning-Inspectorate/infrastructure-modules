/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = azurerm_resource_group.resource_group.name
}

output "webapp_hostname" {
  description = "WebApp hostname"
  value       = module.as.app_service_default_hostname
}

output "webapp_private_ip" {
  description = "WebApp private_ip"
  value       = module.gateway.private_ip
}
