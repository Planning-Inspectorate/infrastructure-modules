/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "load_balancer_name" {
  description = "Name of the load balancer"
  value       = azurerm_lb.lb.name
}

output "load_balancer_id" {
  description = "ID of the load balancer"
  value       = azurerm_lb.lb.id
}

output "private_ip_address" {
  description = "Private ip address of the load balancer"
  value       = azurerm_lb.lb.private_ip_address
}

output "frontend_ip_configurations" {
  description = "All frontend configurations"
  value       = azurerm_lb.lb[*].frontend_ip_configuration
}

output "probe_data" {
  description = "Map probe configuration"
  value       = azurerm_lb_probe.probe
  depends_on  = [azurerm_lb_rule.rule] // stops a race condition between rule creation and external NIC association :(
}

output "load_balancer_backend_ids" {
  description = "Takes the map of backend data and extracts the IDs into a list"
  //value = azurerm_lb_backend_address_pool.backend
  value      = [for k, v in azurerm_lb_backend_address_pool.backend : v.id]
  depends_on = [azurerm_lb_rule.rule] // stops a race condition between rule creation and external NIC association :(
}

# output "load_balancer_backend_address_pools_ids" {
#   description = "Hacked together list of backend address pool IDs"
#   //for_each = toset(var.backend_pool_names)

#   //value       = "${azurerm_lb.lb.id}/backendAddressPools/${each.key}"
#   //value = azurerm_lb_rule.rule[*].backend_address_pool_id
#   value = [for b in var.backend_pool_names : "${azurerm_lb.lb.id}/backendAddressPools/${b}"]
# }