/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "id" {
  description = "The Route ID"
  value       = azurerm_redis_cache.redis.id
}

output "hostname" {
  description = "The Hostname of the Redis Instance"
  value       = azurerm_redis_cache.redis.hostname
}

output "ssl_port" {
  description = " The SSL Port of Redis Instance"
  value       = azurerm_redis_cache.redis.ssl_port
}

output "port" {
  description = "The non-SSL Port of the Redis Instance"
  value       = azurerm_redis_cache.redis.port
}

output "primary_access_key" {
  description = "The Primary Access Key for the Redis Instance"
  value       = azurerm_redis_cache.redis.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The Secondary Access Key for the Redis Instance"
  value       = azurerm_redis_cache.redis.secondary_access_key
  sensitive   = true
}

/* output "redis_configuration" {
    description = "A redis_configuration block. Configuration used only in Premium tier"
    value = "${azurerm_redis_cache.redis.redis_configuration}"
}
 */
