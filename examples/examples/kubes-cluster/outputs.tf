output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = azurerm_resource_group.rg.name
}

output "node_rg_name" {
  description = "Name of the node resource group"
  value       = module.aks.node_rg_name
}

output "cluster_name" {
  description = "Name of the Azure Kubernetes Service"
  value       = module.aks.cluster_name
}

output "kube_config" {
  description = "Config block from azurerm_kubernetes_cluster"
  sensitive   = true
  value       = module.aks.kube_config
}

output "host" {
  description = "Service host used for remote configuration"
  value       = module.aks.host
}

output "fqdn" {
  description = "Service fqdn used for remote configuration"
  value       = module.aks.fqdn
}
