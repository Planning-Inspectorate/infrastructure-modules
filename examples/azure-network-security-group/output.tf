/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "network_security_group_name" {
  description = "Name of the NSG"
  value       = azurerm_network_security_group.nsg.name
}

output "network_security_group_id" {
  description = "The ID of the NSG"
  value       = azurerm_network_security_group.nsg.id

  # Set a dependency here so that parent configs calling this module can be
  # sure all required rules are created before the NSG id is used elsewhere.
  depends_on = [
    azurerm_network_security_rule.nsg_in,
    azurerm_network_security_rule.nsg_out
  ]
}

output "nsg_in_rules" {
  description = "Formatted list of default and user defined NSG rules"
  value       = local.nsg_in_rules
}

output "nsg_out_rules" {
  description = "Formatted list of default and user defined NSG rules"
  value       = local.nsg_out_rules
}
