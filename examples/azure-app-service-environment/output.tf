/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "id" {
  description = "Resource ID of the ASE"
  value       = azurerm_app_service_environment.ase.id
}

output "internal_ip_address" {
  description = "IP address of the internal load balancer"
  value       = azurerm_app_service_environment.ase.internal_ip_address
}

output "outbound_ip_addresses" {
  description = "List of outbound IP addresses"
  value       = azurerm_app_service_environment.ase.outbound_ip_addresses
}

output "service_ip_address" {
  description = "IP address of the service endpoint of the ASE"
  value       = azurerm_app_service_environment.ase.service_ip_address
}