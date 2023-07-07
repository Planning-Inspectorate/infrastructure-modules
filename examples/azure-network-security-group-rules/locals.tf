/*
    Terraform configuration file defining provider configuration
*/
locals {
  nsg_in_rules  = { for key, value in local.central_nsg_in_rules : key => (merge(local.nsg_field_defaults, value)) }
  nsg_out_rules = { for key, value in local.central_nsg_out_rules : key => (merge(local.nsg_field_defaults, value)) }

  central_nsg_in_rules = {
    CentralRule-Monitoring-Solarwinds-in = {
      description                = "Solarwinds rule to allow traffic from server to client machines"
      access                     = "Allow"
      priority                   = 3701
      protocol                   = "Tcp"
      source_port_range          = "*"
      source_address_prefixes    = ["10.209.0.37", "172.28.0.15"]
      destination_port_range     = "17790"
      destination_address_prefix = "*"
    },
    CentralRule-EPO-McAfee-in = {
      description                = "McAfee rule to allow traffic from client machines to McAfee server"
      access                     = "Allow"
      priority                   = 3721
      protocol                   = "Tcp"
      source_port_range          = "*"
      source_address_prefix      = "10.64.3.166"
      destination_port_ranges    = ["80", "443"]
      destination_address_prefix = "*"
    },
    CentralRule-Backups-Commvault-in = {
      description                = "Commvault rule to allow traffic from Commvault Media Agents to client machines"
      access                     = "Allow"
      priority                   = 3761
      protocol                   = "Tcp"
      source_port_range          = "*"
      source_address_prefixes    = ["172.26.16.10", "172.26.16.6", "10.112.2.188", "172.28.0.23", "10.64.0.38"]
      destination_port_ranges    = ["8400", "8401", "8402", "8452", "8600-8699"]
      destination_address_prefix = "*"
    },
    CentralRule-CyberArk-in = {
      description                = "Rule to allow traffic from CyberArk to client machines"
      access                     = "Allow"
      priority                   = 3762
      protocol                   = "Tcp"
      source_port_range          = "*"
      source_address_prefixes    = ["172.28.10.132","172.28.10.133","172.28.10.134","172.28.10.135","172.28.10.136","172.28.10.137","172.28.10.138","172.28.10.139", #North Europe IPs - Doesnt include entire subnet, includes the first 8 usable IPs which will initially be assigned to VMs
                                    "172.26.19.68","172.26.19.69","172.26.19.70","172.26.19.71","172.26.19.72","172.26.19.73","172.26.19.74","172.26.19.75"] # West Europe IPs
      destination_port_ranges    = ["3389", "22"]
      destination_address_prefix = "*"
    },
    CentralRule-Patching-Red-Hat-Satellite-in = {
      description                  = "Red Hat rule to allow traffic Red Hat Capsule to client machines"
      access                       = "Allow"
      priority                     = 3771
      protocol                     = "Tcp"
      source_port_range            = "*"
      source_address_prefixes      = ["172.28.19.96/27", "172.26.19.96/27", "172.28.19.128/27"]
      destination_port_ranges      = ["22","8443"] 
      destination_address_prefix   = "*"
    },
  }

  central_nsg_out_rules = {
    CentralRule-Monitoring-Solarwinds-out = {
      description                  = "Solarwinds rule to allow traffic from client machines to server"
      access                       = "Allow"
      priority                     = 3702
      protocol                     = "Tcp"
      source_port_range            = "*"
      source_address_prefix        = "*"
      destination_port_range       = "17778"
      destination_address_prefixes = ["10.209.0.37", "172.28.0.15"]
    },
    CentralRule-EPO-McAfee-out = {
      description                = "McAfee rule to allow traffic from McAfee server to client machines (Tcp/Udp)"
      access                     = "Allow"
      priority                   = 3723
      protocol                   = "*"
      source_port_range          = "*"
      source_address_prefix      = "*"
      destination_port_ranges    = ["8081","8082","8083"]
      destination_address_prefix = "10.64.3.166"
    },
    CentralRule-Patching-Red-Hat-Satellite-out = {
      description                  = "Red Hat rule to allow traffic from client machines to Red Hat Capsule"
      access                       = "Allow"
      priority                     = 3741
      protocol                     = "Tcp"
      source_port_range            = "*"
      source_address_prefix        = "*"
      destination_port_ranges      = ["80","443","5647","8443","9090"] 
      destination_address_prefixes = ["172.28.19.96/27", "172.26.19.96/27", "172.28.19.128/27"]
    },
    CentralRule-Backups-Commvault-out = {
      description                  = "Commvault rule to allow traffic from client machines to Commvault Media Agents"
      access                       = "Allow"
      priority                     = 3761
      protocol                     = "Tcp"
      source_port_range            = "*"
      source_address_prefix        = "*"
      destination_port_ranges      = ["8400","8401","8402","8452","8600-8699"]
      destination_address_prefixes = ["172.26.16.10","172.26.16.6","10.112.2.188","172.28.0.23","10.64.0.38"]
    }
  }

  nsg_field_defaults = {
    access                                     = null
    description                                = null
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