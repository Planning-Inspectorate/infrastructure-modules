/*
    Terraform configuration file defining outputs
*/

output "pip_id" {
  description = "The ID of the public IP"
  value       = azurerm_public_ip.pip.id
}

output "firewall_id" {
  description = "The ID of the firewall"
  value       = azurerm_firewall.fw.id
}
