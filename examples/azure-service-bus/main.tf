/**
* # azure-service-bus
* 
* This directory stands up a Service Bus instance.
* 
* ## How To Use
*
* ### Service Bus with Queues
*
* ```terraform
* module "sb" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-service-bus"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   queues = [
*     {
*       name = "example1"
*       lock_duration = "PT5M"
*     },
*     {
*       name = "example2"
*       max_delivery_count = 3
*     }
*   ]
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
  name     = "${var.environment}-${var.application}-servicebus-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "random_string" "rnd" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_servicebus_namespace" "sb_namespace" {
  name                = "${var.environment}-${var.application}-servicebus-${random_string.rnd.result}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  sku                 = var.sku
  capacity            = var.capacity[var.sku]
  zone_redundant      = lower(var.sku) == "premium" ? true : false
  tags                = local.tags
}

resource "azurerm_servicebus_namespace_network_rule_set" "rs" {
  count               = lower(var.sku) == "premium" ? 1 : 0
  namespace_name      = azurerm_servicebus_namespace.sb_namespace.name
  resource_group_name = azurerm_servicebus_namespace.sb_namespace.resource_group_name

  default_action = "Deny"

  dynamic "network_rules" {
    for_each = toset(local.subnet_ids)
    content {
      subnet_id = network_rules.key
      # enabling service endpoints cause a network blip to attached devices
      # here we'll allow deployment to subnets missing the endpoint as to not block development
      # users can fix their service endpoints when convienient to avoid disruption
      ignore_missing_vnet_service_endpoint = true
    }
  }

  ip_rules = var.network_rule_ips
}

resource "azurerm_servicebus_namespace_authorization_rule" "sb_namespace_authorization" {
  name                = "namespacerule"
  namespace_name      = azurerm_servicebus_namespace.sb_namespace.name
  resource_group_name = data.azurerm_resource_group.rg.name
  listen              = var.namespace_authorization_rule_listen
  send                = var.namespace_authorization_rule_send
  manage              = var.namespace_authorization_rule_manage
}

resource "azurerm_servicebus_queue" "sb_queue" {
  for_each                                = local.queues
  name                                    = each.key
  resource_group_name                     = data.azurerm_resource_group.rg.name
  namespace_name                          = azurerm_servicebus_namespace.sb_namespace.name
  lock_duration                           = each.value.lock_duration
  max_size_in_megabytes                   = each.value.max_size_in_megabytes
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  requires_session                        = each.value.requires_session
  auto_delete_on_idle                     = each.value.auto_delete_on_idle
  default_message_ttl                     = each.value.default_message_ttl
  dead_lettering_on_message_expiration    = each.value.dead_lettering_on_message_expiration
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  max_delivery_count                      = each.value.max_delivery_count
  status                                  = each.value.status
  enable_batched_operations               = each.value.enable_batched_operations
  enable_express                          = lower(var.sku) == "premium" ? false : true
  enable_partitioning                     = lower(var.sku) == "premium" ? true : false
}

resource "azurerm_servicebus_queue_authorization_rule" "sb_queue_authorization" {
  for_each            = local.queues
  name                = join("-", [each.key, "auth-rule"])
  namespace_name      = azurerm_servicebus_namespace.sb_namespace.name
  queue_name          = azurerm_servicebus_queue.sb_queue[each.key].name
  resource_group_name = data.azurerm_resource_group.rg.name
  listen              = each.value.listen
  send                = each.value.send
  manage              = each.value.manage
}

resource "azurerm_servicebus_topic" "sb_topic" {
  for_each                                = local.topics
  name                                    = each.key
  resource_group_name                     = data.azurerm_resource_group.rg.name
  namespace_name                          = azurerm_servicebus_namespace.sb_namespace.name
  status                                  = each.value.status
  auto_delete_on_idle                     = each.value.auto_delete_on_idle
  default_message_ttl                     = each.value.default_message_ttl
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  enable_batched_operations               = each.value.enable_batched_operations
  enable_express                          = each.value.enable_express
  enable_partitioning                     = lower(var.sku) == "premium" ? false : true
  max_size_in_megabytes                   = each.value.max_size_in_megabytes
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  support_ordering                        = each.value.support_ordering
}

resource "azurerm_servicebus_topic_authorization_rule" "sb_topic_authorization" {
  for_each            = local.topics
  name                = join("-", [each.key, "auth-rule"])
  namespace_name      = azurerm_servicebus_namespace.sb_namespace.name
  topic_name          = azurerm_servicebus_topic.sb_topic[each.key].name
  resource_group_name = data.azurerm_resource_group.rg.name
  listen              = each.value.listen
  send                = each.value.send
  manage              = each.value.manage
}

/*
resource "azurerm_servicebus_subscription" "servicebus_subscription" {
  name                = "tfex_sevicebus_subscription"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  namespace_name      = "${azurerm_servicebus_namespace.servicebus_namespace.name}"
  location            = "${var.location}"
  topic_name          = "${azurerm_servicebus_topic.servicebus_topic.name}"
  max_delivery_count  = 1
  auto_delete_on_idle = ""
  default_message_ttl = ""
  lock_duration = "1"
  dead_lettering_on_message_expiration = false
  enabled_batch_operations = false
  requires_session = false
  forward_to = "queue or topic name"
}

resource "azurerm_servicebus_subscription_rule" "servicebus_subscription_rule" {
  name                = "tfex_sevicebus_rule"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  namespace_name      = "${azurerm_servicebus_namespace.servicebus_namespace.name}"
  topic_name          = "${azurerm_servicebus_topic.servicebus_topic.name}"
  subscription_name   = "${azurerm_servicebus_subscription.example.name}"
  filter_type         = "SqlFilter"
  sql_filter          = "color = 'red'"
}

*/
