/**
* # azure-backup
* 
* This directory contains code to support the deployment of Azure Backup to protect Azure File shares.
* A solution document with extensive details can be found here: https://hiscox.atlassian.net/wiki/spaces/TECH/pages/3541237761/Solution-Azure+Backup
* 
* An example of how to deploy this module can be found in ./examples/azure-file-with-backup
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

resource "azurerm_backup_container_storage_account" "container" {
  resource_group_name = var.vault_resource_group_name
  recovery_vault_name = var.recovery_vault_name
  storage_account_id  = data.azurerm_storage_account.sa.id
}

resource "azurerm_backup_policy_file_share" "file_backup_policy" {
  name                = "${var.environment}-${var.application}-file-backup-policy"
  resource_group_name = var.vault_resource_group_name
  recovery_vault_name = var.recovery_vault_name

  timezone = var.backup_timezone

  backup {
    frequency = var.backup_frequency
    time      = var.backup_time
  }

  retention_daily {
    count = var.daily_backup_retention
  }

  dynamic "retention_weekly" {
    for_each = var.weekly_backup_retention == 0 ? [] : [1]

    content {
      count    = var.weekly_backup_retention
      weekdays = var.weekly_backup_weekdays
    }
  }

  dynamic "retention_monthly" {
    for_each = var.monthly_backup_retention == 0 ? [] : [1]

    content {
      count    = var.monthly_backup_retention
      weekdays = var.monthly_backup_weekdays
      weeks    = var.monthly_backup_weeks
    }
  }

  dynamic "retention_yearly" {
    for_each = var.yearly_backup_retention == 0 ? [] : [1]

    content {
      count    = var.yearly_backup_retention
      weekdays = var.yearly_backup_weekdays
      weeks    = var.yearly_backup_weeks
      months   = var.yearly_backup_months
    }
  }

}

resource "azurerm_backup_protected_file_share" "share" {
  for_each = var.file_share_name

  resource_group_name       = var.vault_resource_group_name
  recovery_vault_name       = var.recovery_vault_name
  source_storage_account_id = data.azurerm_storage_account.sa.id
  source_file_share_name    = each.key
  backup_policy_id          = azurerm_backup_policy_file_share.file_backup_policy.id
  depends_on = [
    azurerm_backup_container_storage_account.container
  ]
}
