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

  default_nsg_in_rules_outbound = {
    azure-loadbalancer-probes-in = {
      access                     = "Allow"
      priority                   = 250
      protocol                   = "Tcp"
      source_port_range          = "*"
      source_address_prefix      = "AzureLoadBalancer"
      destination_port_range     = "*"
      destination_address_prefix = "*"
    }
    # azure-action-group-in = {
    #   access                     = "Allow"
    #   priority                   = 260
    #   protocol                   = "Tcp"
    #   source_port_range          = "*"
    #   source_address_prefix      = "*"
    #   destination_port_range     = "*"
    #   destination_address_prefix = "ActionGroup"
    # }
    # azure-app-insights-in = {
    #   access                     = "Allow"
    #   priority                   = 270
    #   protocol                   = "Tcp"
    #   source_port_range          = "*"
    #   source_address_prefix      = "*"
    #   destination_port_range     = "*"
    #   destination_address_prefix = "ApplicationInsightsAvailability"
    # }
    intra-subnet-traffic-in = {
      access                       = "Allow"
      priority                     = 300
      protocol                     = "*"
      source_port_range            = "*"
      source_address_prefixes      = var.address_prefixes_outbound
      destination_port_range       = "*"
      destination_address_prefixes = var.address_prefixes_outbound
    }
  }
  default_nsg_out_rules_outbound = {
    azure-storage-out = {
      access                     = "Allow"
      priority                   = 260
      protocol                   = "Tcp"
      source_port_range          = "*"
      source_address_prefix      = "*"
      destination_port_range     = "*"
      destination_address_prefix = "Storage"
    }
    azure-monitor-out = {
      access                     = "Allow"
      priority                   = 270
      protocol                   = "Tcp"
      source_port_range          = "*"
      source_address_prefix      = "*"
      destination_port_range     = "*"
      destination_address_prefix = "AzureMonitor"
    }
  }

  nsg_in_rules_outbound  = merge(local.default_nsg_in_rules_outbound, var.nsg_in_rules)
  nsg_out_rules_outbound = merge(local.default_nsg_out_rules_outbound, var.nsg_out_rules)
}
