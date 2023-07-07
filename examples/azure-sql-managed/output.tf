/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "name" {
  value       = azurerm_template_deployment.sqlmi.name
  description = "Name of the managed instance that was created"
}

output "fqdn" {
  value       = azurerm_template_deployment.sqlmi.outputs["fqdn"]
  description = "The fully qualified domain name of the provisioned Managed Instance"
}

