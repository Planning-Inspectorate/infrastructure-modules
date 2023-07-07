/*
    Terraform configuration file defining provider configuration
*/
locals {
  tags = merge(
    tomap({
      application = var.application,
      environment = var.environment,
      repo        = "https://dev.azure.com/hiscox/gp-psg/_git/terraform-modules",
      created     = time_static.t.rfc3339
    }),
    var.tags
  )

  cicd_subnet_ids = [
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/bam-sn-01",
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/vm-sn-01",
    "/subscriptions/c3dbe116-7ab5-4155-89c0-a81dcd9bfe9e/resourceGroups/production-its-subscription-northeurope/providers/Microsoft.Network/virtualNetworks/production-its-vnet-northeurope/subnets/production-itsaks-aks",
    "/subscriptions/c3dbe116-7ab5-4155-89c0-a81dcd9bfe9e/resourceGroups/production-its-subscription-westeurope/providers/Microsoft.Network/virtualNetworks/production-its-vnet-westeurope/subnets/production-itsaks-aks",
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC1-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/prod-platform-aks-node-pool",
    "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/ExpressRoute-RG-TC2-01/providers/Microsoft.Network/virtualNetworks/Core-VN-01/subnets/prod-platform-aks-node-pool"
  ]

  subnet_ids = concat(local.cicd_subnet_ids, var.network_rule_subnet_ids)

  default_queue = {
    lock_duration                           = "PT1M"
    max_size_in_megabytes                   = 1024
    requires_duplicate_detection            = false
    requires_session                        = false
    auto_delete_on_idle                     = "PT1H"
    default_message_ttl                     = "PT10M"
    dead_lettering_on_message_expiration    = false
    duplicate_detection_history_time_window = "PT10M"
    max_delivery_count                      = 10
    status                                  = "Active"
    enable_batched_operations               = true
    listen                                  = true
    send                                    = true
    manage                                  = false
  }

  default_topic = {
    status                                  = "Active"
    auto_delete_on_idle                     = "PT10M"
    default_message_ttl                     = "PT10M"
    duplicate_detection_history_time_window = "PT10M"
    enable_batched_operations               = false
    enable_express                          = false
    max_size_in_megabytes                   = 1024
    requires_duplicate_detection            = false
    support_ordering                        = false
    listen                                  = true
    send                                    = true
    manage                                  = false
  }

  queues = { for v in var.queues : v.name => merge(local.default_queue, v) }
  topics = { for v in var.topics : v.name => merge(local.default_topic, v) }
}
