/*
    Terraform configuration file defining outputs
*/

output "asr_replica_ids" {
  description = "IDs of the replicated VMs"
  value       = [azurerm_site_recovery_replicated_vm.vm-replication[*].id]
}
