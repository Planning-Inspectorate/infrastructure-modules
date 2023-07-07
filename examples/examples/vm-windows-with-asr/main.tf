/**
* # vm-windows
* 
* An example deployment of a Windows based VM with Site Recovery to a DR region
* 
* ## How To Update this README.md
*
* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*
* ## Diagrams
*
* ![image info](./diagrams/design.png)
*
* Unfortunately a number of tools that can parse Terraform code/statefiles and generate architetcure diagrams are limited and most are in their infancy. The built in `terraform graph` is only really useful for looking at dependencies and is too verbose to be considered a diagram on an environment.
*
* We can however turn this on its head and look at using deployed resources to produce a diagram as a stop gap. AzViz is a tool which takes one or more resource groups as input and it will parse their contents and produce a more architecture-like diagram. It will also work out the relation between different resources. Check out all its features [here](https://github.com/PrateekKumarSingh/AzViz). To use it to store a diagram post deployment:
*
* ```pwsh
* Connect-AzAccount
* Set-AzContext -Subscription 'xxxx-xxxx'
* Export-AzViz -ResourceGroup my-resource-group-1, my-rg-2 -Theme light -OutputFormat png -OutputFilePath 'diagrams/design.png' -CategoryDepth 1 -LabelVerbosity 2
* ```
*/

resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-${var.application}-windows-asr-${var.location}"
  location = var.location
  tags     = local.tags
}

module "vm" {
  source                 = "../../azure-vm"
  vm_count_windows       = 1
  environment            = var.environment
  server_environment     = var.server_environment
  application            = var.application
  resource_group_name    = azurerm_resource_group.rg.name
  location               = var.location
  business               = var.business
  service                = var.service
  subnet_id              = data.azurerm_subnet.subnet.id
  vm_size                = var.vm_size
  admin_password         = sensitive(data.azurerm_key_vault_secret.admin_password.value)
  source_image_reference = var.source_image_reference
}

module "storage" {
  source                                  = "../../azure-storage-account"
  resource_group_name                     = azurerm_resource_group.rg.name
  environment                             = var.environment
  application                             = var.application
  location                                = var.location
  storage_replication                     = var.storage_replication
  network_rule_virtual_network_subnet_ids = var.network_rule_virtual_network_subnet_ids
  network_rule_bypass                     = var.network_rule_bypass
  network_default_action                  = "Allow" #"All Networks" require access to ASR cache storage account as per: https://docs.microsoft.com/en-us/azure/site-recovery/azure-to-azure-support-matrix#cache-storage
  tags                                    = local.tags
}

module "asr" {
  source                                  = "../../azure-site-recovery"
  environment                             = var.environment
  application                             = var.application
  location                                = var.location
  resource_group_name_primary             = azurerm_resource_group.rg.name
  source_vm_metadata                      = module.vm.windows_machine_metadata
  target_subnet_name                      = var.subnet_name_dr
  target_vnet_name                        = var.vnet_name_dr
  target_vnet_resource_group              = var.vnet_resource_group_name_dr
  asr_vault_name                          = var.asr_vault_name
  asr_vault_rg                            = var.asr_vault_rg
  asr_primary_fabric_name                 = var.asr_primary_fabric_name
  asr_secondary_fabric_name               = var.asr_secondary_fabric_name
  asr_primary_protection_container_name   = var.asr_primary_protection_container_name
  asr_secondary_protection_container_name = var.asr_secondary_protection_container_name
  asr_policy_name                         = var.asr_policy_name
  cache_storage_account_rg                = azurerm_resource_group.rg.name
  cache_storage_account_name              = module.storage.storage_name
  depends_on = [
    module.vm.windows_machine_metadata,
    module.storage
  ]
}

## Not used in CI/example deployment, but should be included in consumer deployments
#module "diagnostics_asr" {
#  source                     = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-monitor-logging?ref=4.7"
#  target_resource_id         = data.azurerm_recovery_services_vault.vault.id
#  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
#}
