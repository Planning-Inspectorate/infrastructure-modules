output "principal_id" {
  description = "The ID of the principal associated with the Function App"
  value       = azurerm_linux_function_app.function_app.identity[0].principal_id
}

output "app_id" {
  description = "The ID of the Function App"
  value       = azurerm_linux_function_app.function_app.id
}
