/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "id" {
  description = "The ID of the Service Bus Namespace"
  value       = azurerm_servicebus_namespace.sb_namespace.id
}

output "root_namespace_primary_connection_string" {
  description = "Root manager primary connection string for the ServiceBus namespace"
  value       = azurerm_servicebus_namespace.sb_namespace.default_primary_connection_string
}

output "root_namespace_secondary_connection_string" {
  description = "Root manager secondary connection string for the ServiceBus namespace"
  value       = azurerm_servicebus_namespace.sb_namespace.default_secondary_connection_string
}

output "root_namespace_primary_key" {
  description = "Root manager primary key for accessing the namespace"
  value       = azurerm_servicebus_namespace.sb_namespace.default_primary_key
  sensitive   = true
}

output "root_namespace_secondary_key" {
  description = "Root manager secondary key for accessing the namespace"
  value       = azurerm_servicebus_namespace.sb_namespace.default_secondary_key
  sensitive   = true
}

output "namespace_auth_id" {
  description = "ID of the namespace authorization rule"
  value       = azurerm_servicebus_namespace_authorization_rule.sb_namespace_authorization.id
}

output "namespace_auth_primary_connection_string" {
  description = "Primary connection string for the ServiceBus namespace authorization rule"
  value       = azurerm_servicebus_namespace_authorization_rule.sb_namespace_authorization.primary_connection_string
}

output "namespace_auth_secondary_connection_string" {
  description = "Secondary connection string for the ServiceBus namespace authorization rule"
  value       = azurerm_servicebus_namespace_authorization_rule.sb_namespace_authorization.secondary_connection_string
}

output "namespace_auth_primary_key" {
  description = "Primary key for accessing the namespace authorization rule"
  sensitive   = true
  value       = azurerm_servicebus_namespace_authorization_rule.sb_namespace_authorization.primary_key
}

output "namespace_auth_secondary_key" {
  description = "Secondary key for accessing the namespace authorization rule"
  sensitive   = true
  value       = azurerm_servicebus_namespace_authorization_rule.sb_namespace_authorization.secondary_key
}

output "queue_ids" {
  description = "List of queue IDs"
  value       = [for v in azurerm_servicebus_queue.sb_queue : v.id]
}

output "queue_primary_connection_string" {
  description = "List of primary connection strings for the ServiceBus queue"
  value       = [for v in azurerm_servicebus_queue_authorization_rule.sb_queue_authorization : v.primary_connection_string]
}

output "queue_secondary_connection_string" {
  description = "List of secondary connection strings for the ServiceBus queue"
  value       = [for v in azurerm_servicebus_queue_authorization_rule.sb_queue_authorization : v.secondary_connection_string]
}

output "queue_primary_key" {
  description = "List of primary keys for accessing the queue"
  sensitive   = true
  value       = [for v in azurerm_servicebus_queue_authorization_rule.sb_queue_authorization : v.primary_key]
}

output "queue_secondary_key" {
  description = "List of secondary keys for accessing the queue"
  sensitive   = true
  value       = [for v in azurerm_servicebus_queue_authorization_rule.sb_queue_authorization : v.secondary_key]
}

output "topic_ids" {
  description = "List of topic IDs"
  value       = [for v in azurerm_servicebus_topic.sb_topic : v.id]
}

output "topic_primary_connection_string" {
  description = "List of primary connection strings for the ServiceBus topic"
  value       = [for v in azurerm_servicebus_topic_authorization_rule.sb_topic_authorization : v.primary_connection_string]
}

output "topic_secondary_connection_string" {
  description = "List of secondary connection strings for the ServiceBus topic"
  value       = [for v in azurerm_servicebus_topic_authorization_rule.sb_topic_authorization : v.secondary_connection_string]
}

output "topic_primary_key" {
  description = "List of primary keys for accessing the topic"
  sensitive   = true
  value       = [for v in azurerm_servicebus_topic_authorization_rule.sb_topic_authorization : v.primary_key]
}

output "topic_secondary_key" {
  description = "List of secondary keys for accessing the topic"
  sensitive   = true
  value       = [for v in azurerm_servicebus_topic_authorization_rule.sb_topic_authorization : v.secondary_key]
}