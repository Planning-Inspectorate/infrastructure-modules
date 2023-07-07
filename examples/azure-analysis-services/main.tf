/**
* # azure-analysis-services
*
* Provisions a Analysis Services Server
* 
* ## How To Use
*
* * Inputs should be refereced in a module to create your Analysis Services Server of the sort: `module "azure_analysis_services" {...}`
*
* ```HCL
* 
* module "azure_analysis_services" {
*   source                  = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-analysis-services"
*   environment             = var.environment
*   application             = var.application
*   location                = var.location
*   sku                     = var.sku
*   admin_users             = var.admin_users
*   enable_power_bi_service = true
*
*   ipv4_firewall_rule {
*     name        = "myRule1"
*     range_start = "210.117.252.0"
*     range_end   = "210.117.252.255"
*   }
*
*   tags                    = "${var.tags}"
* }
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
  name     = "${var.environment}-${var.application}-analysis-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_analysis_services_server" "analysis_services_server" {
  name                    = "${var.environment}${var.application}analysis${local.location_codes[var.location]}"
  location                = var.location
  resource_group_name     = data.azurerm_resource_group.rg.name
  sku                     = var.sku
  admin_users             = var.admin_users
  enable_power_bi_service = var.enable_power_bi_service

  dynamic "ipv4_firewall_rule" {
    for_each = local.default_ipv4_firewall_rules
    content {
      name        = ipv4_firewall_rule.value.name
      range_start = ipv4_firewall_rule.value.range_start
      range_end   = ipv4_firewall_rule.value.range_end
    }
  }

  dynamic "ipv4_firewall_rule" {
    for_each = var.ipv4_firewall_rules
    content {
      name        = ipv4_firewall_rule.value.name
      range_start = ipv4_firewall_rule.value.range_start
      range_end   = ipv4_firewall_rule.value.range_end
    }
  }

  tags = var.tags

}

