/**
* # azure-network-security-group
* 
* This directory will create an NSG with associated rules. By default it is very strict and will deny all connectivity. To expose various ranges, protocols and ports you will need to provide input values detailed below.
* 
* ## How To Use
*
* Security rules allow multiple ways of specifying certain fields, for instance `source_port_range` and `source_port_ranges`. The difference being that some fields accept a lone string while others accept a list of strings.
*
* By default all fields which have this type of near parity are initialised as `null` such that terraform will fail rather than using `"*"` as a backend default. This ensures that as engineers construct consumers they keep security at the forefront of their mind.
*
* ### Bare NSG - this will block all inbound traffic
*
* ```terraform
* module "nsg" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-network-security-group"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*  }
* ```
*
* ### NSG with Custom Rules
*
* ```terraform
* module "nsg" {
*   source        = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-network-security-group"
*   environment   = "dev"
*   application   = "app"
*   location      = "northeurope"
*   nsg_in_rules  = {
*     azure-https = {
*       access                      = "Allow"
*       priority                    = 300
*       protocol                    = "Tcp"
*       source_port_range           = "*"
*       source_address_prefix       = "172.0.0.0/8"
*       destination_port_ranges     = ["443", "8443"]
*       destionation_address_prefix = "*"
*     }
*     azure-http = {
*       access                      = "Allow"
*       priority                    = 310
*       protocol                    = "Tcp"
*       source_port_ranges          = ["*"]
*       source_address_prefix       = "172.0.0.0/8"
*       destination_port_ranges     = ["80", "8080"]
*       destionation_address_prefix = "*"
*     }
*   }
*   nsg_out_rules = {
*     proxy = {
*       access                        = "Allow"
*       priority                      = 400
*       protocol                      = "*"
*       source_port_ranges            = ["6999", "7070"]
*       source_address_prefixes       = ["172.28.0.0/25", "172.29.0.0/25"]
*       destination_port_range        = "80"
*       destionation_address_prefixes = ["172.28.0.31"]
*     }
*   }
*  }
* ```
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// if you do not specify an existing resurce group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "${var.environment}-${var.application}-nsg-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.environment}-${var.application}-nsg-${var.location}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.tags
}

module "central_nsg_rules" {
  source                      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-network-security-group-rules" # No tag to ensure latest rules are retrieved
  resource_group_name         = var.resource_group_name == "" ? azurerm_resource_group.rg[0].name : var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "nsg_in" {
  for_each                                   = local.nsg_in_rules
  name                                       = each.key
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
  resource_group_name                        = data.azurerm_resource_group.rg.name
  network_security_group_name                = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "nsg_out" {
  for_each                                   = local.nsg_out_rules
  name                                       = each.key
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
  resource_group_name                        = data.azurerm_resource_group.rg.name
  network_security_group_name                = azurerm_network_security_group.nsg.name
}