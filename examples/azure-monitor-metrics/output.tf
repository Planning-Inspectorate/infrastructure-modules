/*
    Terraform configuration file defining outputs
*/

output "metric_id" {
  description = "List of IDs of the metric alert rules"
  value       = [for k, v in azurerm_monitor_metric_alert.alert : v.id]
}