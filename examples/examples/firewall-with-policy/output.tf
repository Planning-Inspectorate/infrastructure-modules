/*
    Terraform configuration file defining outputs
*/

output "firewall_id" {
  description = "ID of the firewall"
  value       = module.fw.firewall_id
}