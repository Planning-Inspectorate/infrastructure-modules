/*
    Terraform configuration file defining local variables
*/
locals {
  tags = merge(
    tomap({
      application = var.application,
      environment = var.environment,
      repo        = "https://dev.azure.com/hiscox/gp-psg/_git/terraform-modules",
      created     = time_static.t.rfc3339
    }),
    var.tags,
  )

  postgresql_database = { for v in var.postgresql_database : v.name => merge(local.default_database, v) }
  default_database = {
    name      = ""
    charset   = "UTF8"
    collation = "English_United States.1252"
  }

  postgresql_configuration = {
    "log_checkpoints"       = "on"
    "log_connections"       = "on"
    "log_disconnections"    = "on"
    "connection_throttling" = "on"
    "log_retention_days"    = "7"
  }

  aad_admin = var.aad_admin_group != "" ? var.aad_admin_group : var.aad_admin_user

  fwrule_sharedBuildAgents = [
    {
      name             = "bam-sn-01"
      start_ip_address = "172.28.2.64"
      end_ip_address   = "172.28.2.95"
    },
    {
      name             = "vm-sn-01"
      start_ip_address = "172.28.0.0"
      end_ip_address   = "172.28.0.254"
    },
    {
      name             = "production-itsaks-aks-ne"
      start_ip_address = "172.20.129.128"
      end_ip_address   = "172.20.129.254"
    },
    {
      name             = "production-itsaks-aks-we"
      start_ip_address = "172.21.129.128"
      end_ip_address   = "172.21.129.254"
    },
    {
      name             = "prod-platform-aks-node-pool-ne"
      start_ip_address = "172.28.7.0"
      end_ip_address   = "172.28.7.127"
    },
    {
      name             = "prod-platform-aks-node-pool-we"
      start_ip_address = "172.26.17.0"
      end_ip_address   = "172.26.17.127"
    },
  ]

  fwrule_allowAzureServices = [
    {
      name             = "allowAzureServices"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    },
  ]

  fwrules = var.fwrule_include_sharedBuildAgents ? concat(local.fwrule_sharedBuildAgents, local.fwrule_allowAzureServices, var.fwrules) : concat(local.fwrule_allowAzureServices, var.fwrules)

}
