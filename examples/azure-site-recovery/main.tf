/**
* # azure-site-recovery
* 
* This directory deploys Azure Site Recovery replicated VMs.
*
* The ASR infrastructure including recovery vault is deployed as part of the azure-subscription repository. This provides re-usable site recovery infrastructure for use within a subscription. Git repo: https://dev.azure.com/hiscox/gp-psg/_git/azure-subscription
*
* If dedicated ASR infrastructure is required for a specific use case, this should be deployed separately.
*
* Either way, data from the site recovery vault is required as input into this module. The necessary information can be found using PowerShell and the Az.RecoveryServices module. For instance:
*
* Set-AzContext -Subscription $subname
* $vault = Get-AzRecoveryServicesVault -Name $vaultname -ResourceGroupName $vaultrg
* $context = Set-AzRecoveryServicesAsrVaultContext -Vault $vault
* $fabrics = Get-AzRecoveryServicesAsrFabric
* $ProtectionContainers = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $fabrics[0]
*
* Future Improvements
* - Email notifications from recovery services vault for critical replication alerts. Currently configurable via Portal but not available in tf.
* - Check Terraform support for changing the replicated VM SKU
*
* ## How To Use
* 
* This module requires various inputs to define the source/primary and target/DR/Secondary infrastructure.
*
* The module requires an input variable to define the source VMs. New outputs named windows_machine_metadata and linux_machine_metadata are available from the vm module which are suitable for this use.
*
* ### Example
* 
* ```terraform
* module "asr" {
*   source                                    = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-site-recovery?ref=4.2"
*   environment                               = var.environment
*   application                               = var.application
*   location                                  = var.location
*   dr_location                               = var.dr_location
*   resource_group_name_primary               = azurerm_resource_group.resource_group.name
*   resource_group_name_dr                    = azurerm_resource_group.resource_group_dr.name
*   target_subnet_name                        = var.subnet_name_dr
*   target_vnet_name                          = var.vnet_name_dr
*   target_vnet_resource_group                = var.vnet_resource_group_name_dr
*   source_vm_metadata                        = module.vm.windows_machine_metadata
* }
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// if you do not specify an existing resurce group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'

resource "azurerm_site_recovery_replicated_vm" "vm-replication" {
  count                                     = length(var.source_vm_metadata)
  name                                      = "${var.source_vm_metadata[count.index].hostname}-asr"
  resource_group_name                       = var.asr_vault_rg
  recovery_vault_name                       = var.asr_vault_name
  source_recovery_fabric_name               = data.azurerm_site_recovery_fabric.primary-fabric.name
  source_vm_id                              = var.source_vm_metadata[count.index].id
  recovery_replication_policy_id            = data.azurerm_site_recovery_replication_policy.policy.id
  source_recovery_protection_container_name = data.azurerm_site_recovery_protection_container.primary-container.name

  target_resource_group_id                = data.azurerm_resource_group.asr_rg.id
  target_recovery_fabric_id               = data.azurerm_site_recovery_fabric.secondary-fabric.id
  target_recovery_protection_container_id = data.azurerm_site_recovery_protection_container.secondary-container.id
  target_network_id                       = "${data.azurerm_resource_group.target_vnet_rg.id}/providers/Microsoft.Network/virtualNetworks/${var.target_vnet_name}"

  dynamic "managed_disk" {
    for_each = var.source_vm_metadata[count.index].disk_ids
    content {
      disk_id                    = managed_disk.value
      staging_storage_account_id = data.azurerm_storage_account.asr-cache.id
      target_resource_group_id   = data.azurerm_resource_group.asr_rg.id
      target_disk_type           = var.source_disk_type
      target_replica_disk_type   = var.source_disk_type
    }
  }

  network_interface {
    source_network_interface_id = var.source_vm_metadata[count.index].nic[0]
    target_subnet_name          = var.target_subnet_name
  }
}