/**
* # azure-data-factory
* 
* This directory stands up an Azure Data Factory instance.
* 
* ## How To Use
*
* ### Plain Data Factory
*
* ```terraform
* module "df" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-data-factory"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*  }
* ```
*
* ### DF With Linked Key Vault
*
* ```terraform
* module "df" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-data-factory"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   linked_key_vault = {
*     devtestapp = {
*       connection_string = ""
*       key_vault_id = data.blah
*       description = ""
*     }
*   }
* }
* ```
*
* ### Data Factory with a Managed Integration Runtime
*
* ```terraform
* module "df" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-data-factory"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   vnet = [{
*     vnet_id = data.blah
*     subnet_name = var.subnet_name
*   }]
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
  name     = "${var.environment}-${var.application}-data-factory-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_data_factory" "df" {
  name                = "${var.environment}-${var.application}-df-${var.location}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  identity {
    type = "SystemAssigned"
  }

  dynamic "vsts_configuration" {

    # Include this block only if var.vsts_configuration is set to a non-null value.

    for_each = [for e in var.vsts_configuration[*] : {
      account_name    = lookup(e, "account_name", null)
      branch_name     = lookup(e, "branch_name", null)
      project_name    = lookup(e, "project_name", null)
      repository_name = lookup(e, "repository_name", null)
      root_folder     = lookup(e, "root_folder", null)
      tenant_id       = lookup(e, "tenant_id", null)
    }]

    content {
      account_name    = vsts_configuration.value.account_name
      branch_name     = vsts_configuration.value.branch_name
      project_name    = vsts_configuration.value.project_name
      repository_name = vsts_configuration.value.repository_name
      root_folder     = vsts_configuration.value.root_folder
      tenant_id       = vsts_configuration.value.tenant_id
    }

  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      # Ignore changes to vsts_configuration
      vsts_configuration
    ]
  }
}

//! READ ME!!!!
// https://github.com/terraform-providers/terraform-provider-azurerm/issues/6264
// the current df resources are missing large chunks of functionality that we require - namely MSI and KV based integrations to other parts of Azure
//! READ ME!!!!

resource "azurerm_data_factory_integration_runtime_managed" "irm" {
  count                            = length(var.vnet_integration) > 0 ? 1 : 0
  name                             = "${var.environment}-${var.application}"
  data_factory_name                = azurerm_data_factory.df.name
  resource_group_name              = data.azurerm_resource_group.rg.name
  location                         = var.location
  node_size                        = var.node_size
  number_of_nodes                  = var.number_of_nodes
  max_parallel_executions_per_node = var.max_parallelism
  edition                          = var.edition
  license_type                     = var.license_type

  dynamic "catalog_info" {
    for_each = var.catalog_info
    content {
      server_endpoint        = catalog_info.value.server_endpoint
      administrator_login    = catalog_info.value.administrator_login
      administrator_password = sensitive(catalog_info.value.administrator_password)
      pricing_tier           = catalog_info.value.pricing_tier
    }
  }

  dynamic "vnet_integration" {
    for_each = var.vnet_integration
    content {
      vnet_id     = vnet_integration.value.vnet_id
      subnet_name = vnet_integration.value.subnet_name
    }
  }
}

resource "azurerm_data_factory_linked_service_sql_server" "sql" {
  for_each = var.linked_sql_server

  name                     = each.key
  resource_group_name      = data.azurerm_resource_group.rg.name
  data_factory_name        = azurerm_data_factory.df.name
  connection_string        = sensitive(each.value.connection_string)
  integration_runtime_name = each.value.runtime_name
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "blob" {
  for_each = var.linked_blob_storage

  name                = "${each.key}-${random_string.rnd.result}" // needs to be globally unique
  resource_group_name = data.azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.df.name
  connection_string   = sensitive(each.value.connection_string)
}

resource "azurerm_data_factory_linked_service_azure_file_storage" "file" {
  for_each = var.linked_file_storage

  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.df.name
  connection_string   = sensitive(each.value.connection_string)
}

resource "azurerm_data_factory_linked_service_key_vault" "kv" {
  for_each = var.linked_key_vault

  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.df.name
  key_vault_id        = each.value.key_vault_id
  description         = each.value.description
}

resource "random_string" "rnd" {
  length  = 4
  special = false
}