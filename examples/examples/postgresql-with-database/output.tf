/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = module.postgresql.resource_group_name
}

output "postgresql_server_name" {
  description = "Name of the PostgreSQL Server"
  value       = module.postgresql.postgresql_server_name
}

output "postgresql_server_fqdn" {
  description = "FQDN of the PostgreSQL Server"
  value       = module.postgresql.postgresql_server_fqdn
}