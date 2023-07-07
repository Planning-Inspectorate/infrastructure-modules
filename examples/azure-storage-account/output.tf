/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "storage_id" {
  description = "Output of the storage account resource id"
  value       = azurerm_storage_account.storage.id
}

output "storage_name" {
  description = "Name of the data storage account"
  value       = azurerm_storage_account.storage.name
}

output "location" {
  description = "Location of the data storage account"
  value       = azurerm_storage_account.storage.location
}

output "primary_access_key" {
  sensitive   = true
  description = "Key used to access storage account"
  value       = azurerm_storage_account.storage.primary_access_key
}

output "secondary_access_key" {
  sensitive   = true
  description = "Key used to access storage account"
  value       = azurerm_storage_account.storage.secondary_access_key
}

output "primary_connection_string" {
  description = "The connection string for the storage account"
  value       = azurerm_storage_account.storage.primary_connection_string
}

output "container_id" {
  description = "The IDs of storage containers"
  value = tolist([
    for container in azurerm_storage_container.container : container.id
  ])
}

output "blob_id" {
  description = "The IDs of blobs"
  value       = azurerm_storage_blob.blob.*.id
}

output "primary_blob_url" {
  description = "Primary URL for accessing the blob storage"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

output "share_id" {
  description = "List of file share IDs"
  value       = azurerm_storage_share.share.*.id
}

// docs says this is valid, azurerm source code says it isn't lol
# output "queue_id" {
#   value = azurerm_storage_queue.queue.*.id
#   description = "IDs of storage queues"
# }
