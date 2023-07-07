/**
* # azure-firewall-policy
* 
* This module deploys an Azure Firewall Policy. You can use this to provide a policy for a firewall or to create a policy from which other polices will inherit a baseline rule set.
*
* Note Application rules cannot have higher priority than NAT/Network rules
*
* Note if your rules are not valid and you attempt to attach the policy to a firewall you'll encounter an Azure InternalServerError
* 
* ## How To Use
*
* ### Example
*
* ```terraform
* module "fwp" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-firewall-policy"
*   resource_group_name = var.vnet_rg
*   environment = var.environment
*   application = var.application
*   location    = var.location
*   tags        = var.tags
*   application_rules = {
*     300 = { # priority must be unique across all rules of all types
*         name = "test2"
*         action = "Allow"
*         rules = { # map of different rules
*             a_rule_name = {
*                 source_addresses = ["192.168.0.2"]
*                 source_ip_groups = []
*                 destination_fqdns =["mushroom.example.com"]
*                 destination_fqdn_tags = []
*                 rule_protocols = { #  map of allowed protocol keys and value port
*                     Https = 443
*                     Http = 80
*                 }
*             }
*         }
*     }
*   }
*   network_rules = {
*       200 = {
*         name = "test3"
*         action = "Deny"
*         rules = {
*           a_rule_name1 = {
*             source_addresses = ["192.168.0.3"]
*             source_ip_groups = []
*             destination_addresses =["192.168.5.0"]
*             destination_ip_groups = []
*             destination_fqdns = []
*             destination_ports = ["80", "1000-2000"]
*             protocols = ["TCP", "UDP"]
*           }
*         }
*       }
*   }
*   nat_rules = {
*       100 = {
*           name = "test4"
*           action = "Dnat"
*           rule_name = "example"
*           rule_source_addresses = ["192.168.0.3"]
*           rule_source_ip_groups = []
*           rule_destination_address = "192.168.253.1"
*           rule_destination_ports = ["80"]
*           rule_protocols = ["TCP"]
*           rule_translated_address = "192.168.20.4"
*           rule_translated_port = 8443
*       }
*   }
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

resource "azurerm_firewall_policy" "fwp" {
  name                = "${var.environment}-${var.application}-fw-policy-${var.location}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  base_policy_id      = var.base_policy_id
  tags                = local.tags
}
// rule names must be uniqiue across all collections hence we have join functions to provide prefixes
resource "azurerm_firewall_policy_rule_collection_group" "fwpcg" {
  name               = "${var.environment}-${var.application}-fw-policy-rulecg-${var.location}"
  firewall_policy_id = azurerm_firewall_policy.fwp.id
  priority           = var.rule_collection_priority

  dynamic "nat_rule_collection" {
    for_each = var.nat_rules

    content {
      name     = join("_", ["nat", nat_rule_collection.value.name])
      priority = nat_rule_collection.key
      action   = nat_rule_collection.value.action
      rule {
        name                = join("_", ["nat_rule", nat_rule_collection.value.rule_name])
        source_addresses    = nat_rule_collection.value.rule_source_addresses
        source_ip_groups    = nat_rule_collection.value.rule_source_ip_groups
        destination_address = nat_rule_collection.value.rule_destination_address
        destination_ports   = nat_rule_collection.value.rule_destination_ports
        protocols           = nat_rule_collection.value.rule_protocols
        translated_address  = nat_rule_collection.value.rule_translated_address
        translated_port     = nat_rule_collection.value.rule_translated_port
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = var.network_rules

    content {
      name     = join("_", ["net", network_rule_collection.value.name])
      priority = network_rule_collection.key
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules

        content {
          name                  = join("_", ["net_rule", rule.key])
          source_addresses      = rule.value.source_addresses
          source_ip_groups      = rule.value.source_ip_groups
          destination_addresses = rule.value.destination_addresses
          destination_ip_groups = rule.value.destination_ip_groups
          destination_fqdns     = rule.value.destination_fqdns
          destination_ports     = rule.value.destination_ports
          protocols             = rule.value.protocols
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = var.application_rules

    content {
      name     = join("_", ["app", application_rule_collection.value.name])
      priority = application_rule_collection.key
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules

        content {
          name                  = join("_", ["app_rule", rule.key])
          source_addresses      = rule.value.source_addresses
          source_ip_groups      = rule.value.source_ip_groups
          destination_fqdns     = rule.value.destination_fqdns
          destination_fqdn_tags = rule.value.destination_fqdn_tags

          dynamic "protocols" {
            for_each = rule.value.rule_protocols

            content {
              type = protocols.key
              port = protocols.value
            }
          }
        }
      }
    }
  }
}
