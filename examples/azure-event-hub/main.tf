/**
* # azure-event-hub
* 
* This directory contains code that is used for deploying and Event Hub Namespace an associated Event Hubs
* 
* ## How To Use
*
* ### Basic
*
* ```terraform
* module "event_hub" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-event-hub"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   event_hubs  = [
*     {
*       name = "first"
*     }
*   ]
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
  name     = join("-", [var.environment, var.application, "eventhub", var.location])
  location = var.location
  tags     = local.tags
}

resource "azurerm_eventhub_namespace" "ehn" {
  name                     = join("-", [var.environment, var.application, random_string.rnd.result])
  location                 = var.location
  resource_group_name      = data.azurerm_resource_group.rg.name
  sku                      = var.sku
  capacity                 = lower(var.sku) == "standard" && var.auto_inflate == false ? var.namespace_capacity : null
  auto_inflate_enabled     = lower(var.sku) == "standard" ? var.auto_inflate : null
  maximum_throughput_units = var.auto_inflate ? var.max_throughput_units : null
  zone_redundant           = lower(var.sku) == "premium" ? true : false
  tags                     = local.tags

  identity {
    type = "SystemAssigned"
  }

  # we'd like to set the network rules like this but it is bugged
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/7014:

  #   network_rulesets {
  #     default_action                 = "Deny"
  #     trusted_service_access_enabled = true

  #     dynamic "virtual_network_rule" {
  #       for_each = toset(local.vnet_rules)

  #       content {
  #         subnet_id                                       = virtual_network_rule.key
  #         ignore_missing_virtual_network_service_endpoint = true
  #       }
  #     }

  #     dynamic "ip_rule" {
  #       for_each = toset(var.ip_rules)

  #       content {
  #         ip_mask = ip_rule.key
  #         action  = "Allow"
  #       }
  #     }
  #   }

  # for the time being we have to do this:

  dynamic "network_rulesets" {
    for_each = length(local.vnet_rules) > 0 || length(var.ip_rules) > 0 ? ["1"] : ["0"]
    content {
      default_action                 = "Deny"
      trusted_service_access_enabled = true

      dynamic "virtual_network_rule" {
        for_each = toset(local.vnet_rules)

        content {
          subnet_id                                       = virtual_network_rule.key
          ignore_missing_virtual_network_service_endpoint = true
        }
      }

      dynamic "ip_rule" {
        for_each = toset(var.ip_rules)

        content {
          ip_mask = ip_rule.key
          action  = "Allow"
        }
      }
    }
  }
}

resource "azurerm_eventhub_namespace_authorization_rule" "namespace_auth_rule" {
  name                = "namespacerule"
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  resource_group_name = azurerm_eventhub_namespace.ehn.resource_group_name

  listen = var.namespace_authorization_rule_listen
  send   = var.namespace_authorization_rule_send
  manage = var.namespace_authorization_rule_manage
}

resource "azurerm_eventhub" "eh" {
  for_each            = local.event_hubs
  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  resource_group_name = azurerm_eventhub_namespace.ehn.resource_group_name
  partition_count     = each.value.partition_count
  message_retention   = each.value.message_retention
  status              = each.value.status

  dynamic "capture_description" {
    // Can only have one or none of these blocks
    for_each = var.capture_description != null ? ["1"] : []
    content {
      enabled             = var.capture_description.enabled
      encoding            = var.capture_description.encoding
      interval_in_seconds = var.capture_description.interval_in_seconds
      size_limit_in_bytes = var.capture_description.size_limit_in_bytes
      skip_empty_archives = var.capture_description.skip_empty_archives

      destination {
        name                = "EventHubArchive.AzureBlockBlob" # cannot be changed
        archive_name_format = var.capture_description.archive_name_format
        blob_container_name = var.capture_description.blob_container_name
        storage_account_id  = var.capture_description.storage_account_id
      }
    }

  }
}

