/*
    Terraform configuration file defining outputs
*/

// Name of the resource group where resources have been deployed to
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "load_balancer_id" {
  description = "ID of the load balancer"
  value       = module.lb.load_balancer_id
}

output "frontend_ip_configurations" {
  description = "All frontend configurations"
  value       = module.lb.frontend_ip_configurations
}

output "load_balancer_backends" {
  description = "List of backend address pool ids"
  value       = module.lb.load_balancer_backend_ids
}
