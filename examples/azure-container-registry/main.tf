/**
* # azure-container-registry
* 
* This directory stands up an ACR.
* 
* ## How To Use
*
* ### Base ACR
*
* ```terraform
* module "acr" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-container-registry"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
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
  name     = "${var.environment}-${var.application}-container-registry-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_container_registry" "acr" {
  //? does the name have to be globally unique? if so add a random
  name                     = "${var.environment}${var.application}${random_string.rnd.result}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = var.location
  admin_enabled            = var.admin_enabled
  sku                      = "Premium"
  georeplication_locations = var.georeplication_locations

  # dynamic "network_rule_set" {
  #   for_each = var.network_rule_set
  #   content {
  #     default_action = "Deny"
  #     # dynamic "ip_rule" {

  #     # }
  #     # virtual_network {

  #     # }
  #   }
  # }

  // bug in network_rule_set so dynamic isn't working https://github.com/hashicorp/terraform/issues/22340
  network_rule_set {
    default_action = var.default_action

    # Commented out temporarily due to bug above - iterator-style workaround below
    # dynamic "ip_rule" {
    #   for_each = var.ip_rules
    #   content {
    #     action   = ip_rules.value.action
    #     ip_range = ip_rules.value.range
    #   }
    # }
    ip_rule = [
      for i in var.ip_rules : {
        action   = i.action
        ip_range = i.ip_range
      }
    ]

    # Commented out temporarily due to bug above - iterator-style workaround below
    # dynamic "virtual_network" {
    #   for_each = var.virtual_networks
    #   content {
    #     action   = virtual_networks.value.action
    #     ip_range = virtual_networks.value.subnet_id
    #   }
    # }
    virtual_network = [
      for v in var.virtual_networks : {
        action    = v.action
        subnet_id = v.subnet_id
      }
    ]
  }

  tags = local.tags
}

