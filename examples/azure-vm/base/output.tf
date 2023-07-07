output "resource_group_name" {
  value = var.resource_group_name
}

output "storage_id" {
  value = var.existing_storage_account_name == "" ?  azurerm_storage_account.storage_account[*].id : data.azurerm_storage_account.storage_account[*].id
}

output "storage_name" {
  value = var.existing_storage_account_name == "" ? azurerm_storage_account.storage_account[*].name : data.azurerm_storage_account.storage_account[*].name
}

output "storage_uri" {
  value = var.existing_storage_account_name == "" ? azurerm_storage_account.storage_account[*].primary_blob_endpoint : data.azurerm_storage_account.storage_account[*].primary_blob_endpoint
}

output "network_interface_ids" {
  value = azurerm_network_interface.network_interface[*].id
}

output "network_interface_ips" {
  value = azurerm_network_interface.network_interface[*].private_ip_address
}

output "availability_set_id" {
  value = azurerm_availability_set.availability_set.id
}

output "network_security_group_name" {
  value = azurerm_network_security_group.network_security_group[*].name
}

output "network_security_group_id" {
  value = azurerm_network_security_group.network_security_group[*].id
}

output "public_ip_names" {
  value = azurerm_public_ip.public_ip[*].name
}

output "public_ip_ids" {
  value = azurerm_public_ip.public_ip[*].id
}

output "application_security_group_id" {
  value = azurerm_application_security_group.application_security_group.id
}

