/**
* # azure-logic-app-standard
* 
* This directory contains code that is used to deploy an Azure Logic App Standard. Note that to restrict outbound traffic from the App to a private network you should use the `azurerm_app_service_virtual_network_swift_connection` resource and add an `app_setting` called "WEBSITE_VNET_ROUTE_ALL" with a value of "1" to enable it. To restrict Inbound traffic you have two options available, first you can use IP restrictions under site_config to allow/deny addresses and service tags, second you could use a Private Endpoint to enforce private inbound flow - note that you cannot use both of these together, Private Endpoints overide IP restrictions.
* 
* ## How To Use
*
* ### Basic
*
* ```
* module "las" {
*   source                     = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-logic-app-standard?ref=1.0.5"
*   environment                = var.environment
*   application                = var.application
*   resource_group_name        = azurerm_resource_group.resource_group.name
*   location                   = var.location
*   app_service_plan_id        = module.asp.id
*   storage_account_name       = module.storage.storage_name
*   storage_account_access_key = module.storage.primary_access_key
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
  name     = "${var.environment}-${var.application}-las-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_logic_app_standard" "las" {
  name                       = join("-", [var.environment, var.application, random_string.rnd.result])
  location                   = var.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  storage_account_share_name = var.storage_account_share_name
  use_extension_bundle       = true
  client_affinity_enabled    = var.client_affinity_enabled
  client_certificate_mode    = var.client_certificate_mode
  enabled                    = true
  https_only                 = true
  identity {
    type = length(var.identity_ids) == 0 ? "SystemAssigned" : "UserAssigned"
    // NB: identity_ids doesn't work, it's a provider bug
    # identity_ids = length(var.identity_ids) == 0 ? null : var.identity_ids
  }
  version = var.runtime_version
  tags    = local.tags

  dynamic "connection_string" {
    for_each = var.connection_string
    content {
      name  = connection_string.value["name"]
      type  = connection_string.value["type"]
      value = connection_string.value["value"]
    }
  }

  site_config {
    always_on       = local.site_config["always_on"]
    app_scale_limit = local.site_config["app_scale_limit"]
    cors {
      allowed_origins     = local.site_config.cors["allowed_origins"]
      support_credentials = local.site_config.cors["support_credentials"]
    }
    dotnet_framework_version  = local.site_config["dotnet_framework_version"]
    elastic_instance_minimum  = local.site_config["elastic_instance_minimum"]
    ftps_state                = local.site_config["ftps_state"]
    health_check_path         = local.site_config["health_check_path"]
    http2_enabled             = local.site_config["http2_enabled"]
    linux_fx_version          = local.site_config["linux_fx_version"]
    min_tls_version           = local.site_config["min_tls_version"]
    pre_warmed_instance_count = local.site_config["pre_warmed_instance_count"]
    use_32_bit_worker_process = local.site_config["use_32_bit_worker_process"]
    websockets_enabled        = local.site_config["websockets_enabled"]
    dynamic "ip_restriction" {
      for_each = local.site_config.ip_restrictions.ip_addresses
      iterator = ip_addresses
      content {
        ip_address = ip_addresses.value["ip_address"]
        name       = ip_addresses.value["name"]
        priority   = ip_addresses.value["priority"]
        action     = ip_addresses.value["action"]
      }
    }
    dynamic "ip_restriction" {
      for_each = local.site_config.ip_restrictions.service_tags
      iterator = service_tags
      content {
        service_tag = service_tags.value["service_tag_name"]
        name        = service_tags.value["name"]
        priority    = service_tags.value["priority"]
        action      = service_tags.value["action"]
      }
    }
    dynamic "ip_restriction" {
      for_each = local.site_config.ip_restrictions.subnet_ids
      iterator = subnet_ids
      content {
        virtual_network_subnet_id = subnet_ids.value["subnet_id"]
        name                      = subnet_ids.value["name"]
        priority                  = subnet_ids.value["priority"]
        action                    = subnet_ids.value["action"]
      }
    }
  }

  app_settings = var.app_settings
}

