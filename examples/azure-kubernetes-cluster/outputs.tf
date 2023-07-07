/*
    Terraform configuration file defining outputs
*/

output "resource_group_name" {
  description = "Name of the resource group where resources have been deployed to"
  value       = data.azurerm_resource_group.rg.name
}

output "node_rg_name" {
  description = "Name of the node resource group"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "cluster_name" {
  description = "Name of the Azure Kubernetes Service"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_id" {
  description = "Name of the Azure Kubernetes Service"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "aks_msi_id" {
  description = "ID of the AKS MSI"
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

output "kube_config" {
  description = "Config block from azurerm_kubernetes_cluster"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
}

output "host" {
  description = "Service host used for remote configuration"
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.host
}

output "fqdn" {
  description = "Service fqdn used for remote configuration"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "cluster_username" {
  description = "Username required to administer cluster"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.username
}

output "cluster_password" {
  description = "Password required to administer cluster"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.password
}

output "client_key" {
  description = "Private key required to authenticate to the cluster, base64 encoded"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
}

output "client_certificate" {
  description = "Public certificate used by clients to authenticate the cluster, base64 encoded"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
}

output "cluster_ca_certificate" {
  description = "CA certificate used as root of trust for the cluster, base64 encoded"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
}

output "kube_config_admin" {
  description = "Admin config block from azurerm_kubernetes_cluster"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
}

output "cluster_username_admin" {
  description = "Admin username required to administer cluster"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.username
}

output "cluster_password_admin" {
  description = "Admin password required to administer cluster"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.password
}

output "client_key_admin" {
  description = "Admin private key required to authenticate to the cluster, base64 encoded"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key
}

output "client_certificate_admin" {
  description = "Admin public certificate used by clients to authenticate the cluster, base64 encoded"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate
}

output "cluster_ca_certificate_admin" {
  description = "Admin CA certificate used as root of trust for the cluster, base64 encoded"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate
}
