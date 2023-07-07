/*
    Terraform configuration file defining provider configuration
*/
locals {
  tags = merge(
    tomap({
      application = var.application,
      environment = var.environment,
      repo = "https://dev.azure.com/hiscox/gp-psg/_git/terraform-modules",
      created = time_static.t.rfc3339
    }),
    var.tags,
  )

  aad_admin = var.aad_admin_group != "" ? var.aad_admin_group : var.aad_admin_user

  synrbacadmin = [
    {
      role_name    = "Synapse Administrator"
      principal_id = var.aad_admin_group != "" ? data.azuread_group.aad_admin_group[0].object_id : data.azuread_user.aad_admin_user[0].object_id
    }
  ]

  synrbacroles = concat(local.synrbacadmin, var.synrbacroles)
  
  default_sqlpool = {
    collation = null
  }

  sqlpools = {for s in var.sqlpools : s.name => merge(local.default_sqlpool, s)}

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
    }
  ]

  fwrule_allowAzureServices = [
    {
      name             = "AllowAllWindowsAzureIps"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    },
  ]

  fwrules = var.fwrule_include_sharedBuildAgents ? concat(local.fwrule_sharedBuildAgents, local.fwrule_allowAzureServices, var.fwrules) : concat(local.fwrule_allowAzureServices, var.fwrules)

}
