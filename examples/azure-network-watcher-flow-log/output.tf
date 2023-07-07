/*
    Terraform configuration file defining outputs
*/

output "network_watcher_id" {
  description = "Network watcher Flow ID"
  value       = var.analytics ? azurerm_network_watcher_flow_log.flow_log[0].id : azurerm_network_watcher_flow_log.flow_log_simple[0].id
}