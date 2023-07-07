/**
* # azure-network-security-group-rules
* 
* This directory creates a number of central rules that are to be deployed to every Terraform NSG deployment.
*
* Rules updated 27/04/2022 to include Satellite
* 
* ## How To Use
*
* Unusually, this module is not intended to be deployed independently of the main azure-network-security-group module but instead is referenced by that module. 
* 
* The reason this module is separate is the intention is for this module to be non-tagged so changes to the rules are reflected regardless of tagged version of NSG module.
*
* Please note: This may mean that changes are required in Terraform even when nothing has changed in code (as the rules have changed)
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

resource "azurerm_network_security_rule" "nsg_in" {
  for_each                                   = local.nsg_in_rules
  name                                       = each.key
  description                                = each.value.description
  direction                                  = "Inbound"
  access                                     = each.value.access
  priority                                   = each.value.priority
  protocol                                   = each.value.protocol
  source_port_range                          = each.value.source_port_range
  source_port_ranges                         = each.value.source_port_ranges
  source_address_prefix                      = each.value.source_address_prefix
  source_address_prefixes                    = each.value.source_address_prefixes
  source_application_security_group_ids      = each.value.source_application_security_group_ids
  destination_port_range                     = each.value.destination_port_range
  destination_port_ranges                    = each.value.destination_port_ranges
  destination_address_prefix                 = each.value.destination_address_prefix
  destination_address_prefixes               = each.value.destination_address_prefixes
  destination_application_security_group_ids = each.value.destination_application_security_group_ids
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = var.network_security_group_name
}

resource "azurerm_network_security_rule" "nsg_out" {
  for_each                                   = local.nsg_out_rules
  name                                       = each.key
  description                                = each.value.description
  direction                                  = "Outbound"
  access                                     = each.value.access
  priority                                   = each.value.priority
  protocol                                   = each.value.protocol
  source_port_range                          = each.value.source_port_range
  source_port_ranges                         = each.value.source_port_ranges
  source_address_prefix                      = each.value.source_address_prefix
  source_address_prefixes                    = each.value.source_address_prefixes
  source_application_security_group_ids      = each.value.source_application_security_group_ids
  destination_port_range                     = each.value.destination_port_range
  destination_port_ranges                    = each.value.destination_port_ranges
  destination_address_prefix                 = each.value.destination_address_prefix
  destination_address_prefixes               = each.value.destination_address_prefixes
  destination_application_security_group_ids = each.value.destination_application_security_group_ids
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = var.network_security_group_name
}
