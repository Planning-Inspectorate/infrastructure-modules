/**
* # azure-file-with-backup
* 
* An example deployment of an Azure File share with Azure Backup.
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

module "storage" {
  source                   = "../../azure-storage-account"
  environment              = var.environment
  application              = var.application
  location                 = var.location
  storage_replication      = var.storage_replication
  access_tier              = var.access_tier
  large_file_share_enabled = var.large_file_share_enabled
  shares                   = var.shares
  tags                     = local.tags
  network_rule_ips         = var.network_rule_ips
  network_rule_bypass      = var.network_rule_bypass
}

module "backup" {
  source                    = "../../azure-backup"
  environment               = var.environment
  application               = var.application
  vault_resource_group_name = var.vault_resource_group_name
  recovery_vault_name       = var.recovery_vault_name
  storage_account_name      = module.storage.storage_name
  storage_account_rg        = module.storage.resource_group_name
  file_share_name           = local.share_names
  backup_frequency          = var.backup_frequency
  backup_time               = var.backup_time
  daily_backup_retention    = var.daily_backup_retention
  weekly_backup_retention   = var.weekly_backup_retention
  weekly_backup_weekdays    = var.weekly_backup_weekdays
  monthly_backup_retention  = var.monthly_backup_retention
  monthly_backup_weekdays   = var.monthly_backup_weekdays
  monthly_backup_weeks      = var.monthly_backup_weeks

}