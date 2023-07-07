/*
    Terraform configuration file defining outputs
*/

output "log_monitoring_catagories" {
  description = "The available catagories that can be logged for the provided resource"
  value       = data.azurerm_monitor_diagnostic_categories.catagories.logs
}

output "diagnostics_setting_id" {
  description = "The ID of the created diagnostic setting"
  value       = azurerm_monitor_diagnostic_setting.diag.id
}