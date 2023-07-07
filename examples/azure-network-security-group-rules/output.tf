/*
    Terraform configuration file defining outputs
*/

output "nsg_in_rules" {
  description = "Formatted list of default and user defined NSG rules"
  value       = local.nsg_in_rules
}

output "nsg_out_rules" {
  description = "Formatted list of default and user defined NSG rules"
  value       = local.nsg_out_rules
}
