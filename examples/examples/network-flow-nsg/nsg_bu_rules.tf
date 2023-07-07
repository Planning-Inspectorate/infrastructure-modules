locals {
  bu_dest_port = "22"
  bu_nsg_in_rules = {
    permit_plat_prod_inbound = {
      priority                = 3800
      source_address_prefixes = ["172.28.0.0/16", "172.26.16.0/24", "172.29.16.0/24"]
    },
    permit_plat_devtest_inbound = {
      priority                = 3810
      source_address_prefixes = ["172.29.32.0/21"]
    },
    permit_its_prod_inbound = {
      priority                = 3820
      source_address_prefixes = ["172.20.128.0/21", "172.21.128.0/21"]
    },
    permit_its_devtest_inbound = {
      priority                = 3830
      source_address_prefixes = ["172.20.192.0/21", "172.21.192.0/21", "172.31.0.0/16"]
    },
    permit_group_prod_inbound = {
      priority                = 3840
      source_address_prefixes = ["172.26.224.0/24", "172.26.228.0/24", "172.26.229.0/24", "172.26.231.0/24", "172.26.8.0/21", "172.29.8.0/21", "172.29.224.0/24", "172.29.228.0/24", "172.29.229.0/24", "172.29.231.0/24"]
    },
    permit_group_devtest_inbound = {
      priority                = 3850
      source_address_prefixes = ["172.24.127.0/24", "172.29.225.0/24", "172.29.226.0/24", "172.29.227.0/24", "172.29.230.0/24", "172.29.80.0/21"]
    },
    permit_eu_prod_inbound = {
      priority                = 3860
      source_address_prefixes = ["172.29.112.0/20", "172.26.112.0/20"]
    },
    permit_eu_devtest_inbound = {
      priority                = 3870
      source_address_prefixes = ["172.23.0.0/21", "172.29.128.0/20", "172.26.128.0/20"]
    },
    permit_uk_prod_inbound = {
      priority                = 3880
      source_address_prefixes = ["172.29.48.0/20", "172.26.1.192/26", "172.26.32.0/20"]
    },
    permit_uk_devtest_inbound = {
      priority                = 3890
      source_address_prefixes = ["172.29.64.0/20"]
    },
    permit_uk_integration_devtest_inbound = {
      priority                = 3910
      source_address_prefixes = ["172.23.32.0/21"]
    },
    permit_re_prod_inbound = {
      priority                = 3920
      source_address_prefixes = ["172.24.128.0/20", "172.25.128.0/20"]
    },
    permit_re_devtest_inbound = {
      priority                = 3930
      source_address_prefixes = ["172.24.192.0/20", "172.21.16.0/20"]
    },
    permit_usa_prod_inbound = {
      priority                = 3940
      source_address_prefixes = ["172.29.160.0/20", "172.26.160.0/20"]
    },
    permit_usa_devtest_inbound = {
      priority                = 3950
      source_address_prefixes = ["172.26.144.0/20", "172.29.144.0/20"]
    },
    permit_lm_prod_inbound = {
      priority                = 3960
      source_address_prefixes = ["172.29.192.0/20", "172.26.192.0/20"]
    },
    permit_lm_devtest_inbound = {
      priority                = 3970
      source_address_prefixes = ["172.18.64.0/18", "172.29.208.0/20"]
    },
    permit_core_inbound = {
      priority                = 3980
      source_address_prefixes = ["172.20.0.0/20", "172.29.208.0/20"]
    },
    hiscox_catch_all = {
      priority                = 4050
      source_address_prefixes = ["172.16.0.0/12"]
    },
  }
}

resource "azurerm_network_security_rule" "nsg_in" {
  for_each                                   = local.bu_nsg_in_rules
  name                                       = each.key
  direction                                  = "Inbound"
  access                                     = "Allow"
  priority                                   = each.value.priority
  source_address_prefixes                    = each.value.source_address_prefixes
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_application_security_group_ids = module.vm.application_security_group_id_linux
  destination_port_range                     = local.bu_dest_port
  resource_group_name                        = azurerm_resource_group.resource_group.name
  network_security_group_name                = module.nsg.network_security_group_name
}
