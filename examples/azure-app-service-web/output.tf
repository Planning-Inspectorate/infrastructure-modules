/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "id" {
  description = "ID of the App Service"
  value       = azurerm_app_service.as[*].id
}

output "custom_domain_verification_id" {
  description = "ID of the App Service Custom Domain Verification"
  value       = azurerm_app_service.as[*].custom_domain_verification_id
}

output "identity" {
  description = "Identity block of the app service"
  value       = azurerm_app_service.as[*].identity
}

output "app_service_default_hostname" {
  description = "Default hostname of the app service"
  value       = one(azurerm_app_service.as[*].default_site_hostname)
}
