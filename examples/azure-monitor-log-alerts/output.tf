/*
    Terraform configuration file defining outputs
*/

output "ids" {
  description = "List of IDs of the scheduled query alerts"
  value       = [for i in azurerm_monitor_scheduled_query_rules_alert.query : i.id]
}
