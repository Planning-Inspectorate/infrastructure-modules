/*
    Terraform configuration file defining provider configuration
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

  location_codes = {
    "northeurope" = "ne"
    "westeurope"  = "we"
    "ukwest"      = "uk"
  }

  #The default firewall rules of cicd subnets 
  cicd_ipv4_firewall_rules = [
    {
      name        = "bam-sn-01"
      range_start = "172.28.2.65"
      range_end   = "172.28.2.94"
    },
    {
      name        = "VM-SN-01"
      range_start = "172.28.0.1"
      range_end   = "172.28.0.254"
    },
    {
      name        = "production-itsaks-aks"
      range_start = "172.20.129.128"
      range_end   = "172.20.129.255"
    },
    {
      name        = "production-itsaks-aks-westeurope"
      range_start = "172.21.129.128"
      range_end   = "172.21.129.255"
    },
    {
      name        = "prod-platform-aks-northeurope"
      range_start = "172.28.7.1"
      range_end   = "172.28.7.128"
    },
    {
      name        = "prod-platform-aks-westeurope"
      range_start = "172.26.17.1"
      range_end   = "172.26.17.128"
    }
  ]

  default_ipv4_firewall_rules = var.ipv4_firewall_rules_include_cicd_agents ? local.cicd_ipv4_firewall_rules : []
}

