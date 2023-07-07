/*
    Terraform configuration file defining outputs
*/

output "subnet_id" {
  description = "Id of the subnet"
  value       = azurerm_subnet.subnet.id
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = azurerm_subnet.subnet.name
}

output "address_prefixes" {
  description = "Address prefix of the subnet"
  value       = azurerm_subnet.subnet.address_prefixes
}

