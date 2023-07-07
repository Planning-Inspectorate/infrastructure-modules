/**
* # azure-cosmosdb
* 
* This directory stands up a CosmosDb instance
* 
* ## How To Use
* 
*
* ### Basic CosmosDb Account
*
* ```terraform
* module "tempalte" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-cosmosdb"
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
  name     = "${var.environment}-${var.application}-cosmosdb-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "${var.environment}${var.application}cosmos-${random_integer.ri.result}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  offer_type          = "Standard" # can only be standard
  kind                = var.kind
  tags                = local.tags

  enable_automatic_failover         = var.auto_failover
  is_virtual_network_filter_enabled = var.subnet_id == [] ? false : true
  enable_multiple_write_locations   = true

  consistency_policy {
    consistency_level = var.consistency_level
  }

  geo_location {
    location          = var.failover_location
    failover_priority = 1
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  dynamic "virtual_network_rule" {
    for_each = concat(local.cicd_subnet_ids, var.subnet_id)
    content {
      id                                   = virtual_network_rule.value
      ignore_missing_vnet_service_endpoint = true
    }
  }

  ip_range_filter = var.ip_range_filter
  # capabilities {
  #   name = "${var.capabilities}"
  # }
}

