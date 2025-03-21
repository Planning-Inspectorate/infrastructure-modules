output "default_site_hostname" {
  description = "The Default Hostname associated with the App Service"
  value       = azurerm_linux_web_app.web_app.default_hostname
}

output "principal_id" {
  description = "The ID of the principal associated with the App Service"
  value       = azurerm_linux_web_app.web_app.identity[0].principal_id
}

output "staging_principal_id" {
  description = "The ID of the principal associated with the App Service staging slot"
  value       = azurerm_linux_web_app_slot.staging.identity[0].principal_id
}

output "id" {
  description = "The ID of the App Service"
  value       = azurerm_linux_web_app.web_app.id
}
