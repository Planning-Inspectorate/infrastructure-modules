environment    = "ci"
application    = "func"
location       = "northeurope"
site_config = {
  java_version = "11"
  ip_restrictions = {
    ip_addresses = [
      {
        rule_name  = "IPRestriction"
        ip_address = "95.147.106.189/24"
        priority   = 100
        action     = "Deny"
      }
    ]
    service_tags = [
      {
        rule_name        = "ActionGroupTagRule"
        service_tag_name = "ActionGroup"
        priority         = 100
        action           = "Deny"
      },
      {
        rule_name        = "LogicAppsTagRule"
        service_tag_name = "LogicApps"
        priority         = 200
        action           = "Deny"
      }
    ]
    subnet_ids = [
      {
        rule_name = "SubnetRestriction"
        subnet_id = "/subscriptions/41dac0b7-f808-4ae6-94f2-010b5cc2b358/resourceGroups/devtest-itspsg-subscription-northeurope/providers/Microsoft.Network/virtualNetworks/devtest-its-vnet-northeurope/subnets/devtest-its-vm"
        priority  = 200
        action    = "Allow"
      }
    ]
  }
}