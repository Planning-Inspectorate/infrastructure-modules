/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "id" {
  description = "ID of the AAG"
  value       = azurerm_application_gateway.waf.id
}

output "name" {
  description = "Name of the AAG"
  value       = azurerm_application_gateway.waf.name
}

output "public_ip" {
  description = "Public IP"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "private_ip" {
  description = "Private IP"
  value       = azurerm_application_gateway.waf.frontend_ip_configuration[0].private_ip_address
}