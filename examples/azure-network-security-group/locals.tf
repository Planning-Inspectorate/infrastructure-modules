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
    var.tags
  )

  // create combined maps of default nsg rules and user defined nsg rules
  nsg_in_rules_combined  = merge(local.default_nsg_in_rules, var.nsg_in_rules)
  nsg_out_rules_combined = merge(local.default_nsg_out_rules, var.nsg_out_rules)

  // defaults specify -in and -out in their names otherwise if they have the same name terraform overwrites them and every apply will slip rules between Inbound and Outbound. It's weird

  // service tags can be useful for Azure Service access: https://docs.microsoft.com/en-us/azure/virtual-network/service-tags-overview

  default_nsg_in_rules = {
    deny-all-in = {
      access                     = "Deny"
      priority                   = 4096
      protocol                   = "*"
      source_port_range          = "*"
      source_address_prefix      = "*"
      destination_port_range     = "*"
      destination_address_prefix = "*"
    }
  }

  default_nsg_out_rules = {
    # az-storage-out = {
    #   access                     = "Allow"
    #   priority                   = 4040
    #   protocol                   = "*"
    #   source_port_range          = "*"
    #   source_address_prefix      = "VirtualNetwork"
    #   destination_port_range     = "*"
    #   destination_address_prefix = "Storage"
    # }
    # az-monitor-out = {
    #   access                     = "Allow"
    #   priority                   = 4050
    #   protocol                   = "*"
    #   source_port_range          = "*"
    #   source_address_prefix      = "VirtualNetwork"
    #   destination_port_range     = "*"
    #   destination_address_prefix = "AzureMonitor"
    # }
    # deny-all-out = {
    #   access                     = "Deny"
    #   priority                   = 4096
    #   protocol                   = "*"
    #   source_port_range          = "*"
    #   source_address_prefix      = "*"
    #   destination_port_range     = "*"
    #   destination_address_prefix = "*"
    # }
  }

  // format the nsg rules so unused fields are set to null
  nsg_in_rules  = { for key, value in local.nsg_in_rules_combined : key => (merge(local.nsg_field_defaults, value)) }
  nsg_out_rules = { for key, value in local.nsg_out_rules_combined : key => (merge(local.nsg_field_defaults, value)) }

  nsg_field_defaults = {
    access                                     = null
    priority                                   = null
    protocol                                   = null
    source_port_range                          = null
    source_port_ranges                         = null
    source_address_prefix                      = null
    source_address_prefixes                    = null
    source_application_security_group_ids      = null
    destination_port_range                     = null
    destination_port_ranges                    = null
    destination_address_prefix                 = null
    destination_address_prefixes               = null
    destination_application_security_group_ids = null
  }
}