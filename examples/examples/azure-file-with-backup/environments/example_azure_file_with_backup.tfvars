/*
    Terraform configuration file defining variable value for this environment
*/
environment              = "ci"
application              = "examplefilesharebackup"
location                 = "northeurope"
storage_replication      = "LRS"
access_tier              = "Cool"
large_file_share_enabled = "true"
network_rule_bypass      = ["AzureServices"]
network_rule_ips         = ["79.69.140.72"]
shares = [
  {
    name  = "ci-file-share-1"
    quota = "50"
  },
  {
    name  = "ci-file-share-2"
    quota = "25"
  },
]

backup_time = "01:30"
daily_backup_retention = 3
weekly_backup_retention = 4
weekly_backup_weekdays = ["Sunday"]
monthly_backup_retention = 12
monthly_backup_weekdays = ["Sunday"]
monthly_backup_weeks = ["First"]

recovery_vault_name = "devtest-its-asr-recovery-vault"
vault_resource_group_name = "devtest-itspsg-subscription-northeurope"