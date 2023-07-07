/**
* # app-service-function
*
* Creates an Azure App Service (Function)
*
* ## How To Use
*
* ### Function App 
*
* ```terraform
* module "func" {
*   source                     = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-app-service"
*   app_service_plan_id        = module.asp.id
*   environment                = var.environment
*   application                = var.application
*   location                   = var.location
*   storage_account_name       = var.storage_account_name
*   storage_account_access_key = var.storage_account_access_key
* }
* ```
*
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions [here](https://github.com/segmentio/terraform-docs)
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// if you do not specify an existing resource group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "${var.environment}-${var.application}-appservicefun-${var.location}"
  location = var.location
  tags     = local.tags
}

// function app names must be globally unique so we append a random string
resource "random_string" "rand" {
  length  = 4
  special = false
  upper   = false
}

# Create function app
resource "azurerm_function_app" "function" {
  name                       = "${var.environment}-${var.application}-${random_string.rand.result}"
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = var.location
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  https_only                 = true
  tags                       = local.tags
  version                    = var.function_version
  app_settings               = var.app_settings
  site_config {
    always_on = local.site_config["always_on"]
    cors {
      allowed_origins     = local.site_config.cors["allowed_origins"]
      support_credentials = local.site_config.cors["support_credentials"]
    }
    ftps_state                  = local.site_config["ftps_state"] == "AllAllowed" ? "FtpsOnly" : local.site_config["ftps_state"]
    health_check_path           = local.site_config["health_check_path"]
    http2_enabled               = local.site_config["http2_enabled"]
    java_version                = local.site_config["java_version"]
    linux_fx_version            = local.site_config["linux_fx_version"]
    dotnet_framework_version    = local.site_config["dotnet_framework_version"]
    min_tls_version             = local.site_config["min_tls_version"] == "1.0" || local.site_config["min_tls_version"] == "1.1" ? "1.2" : local.site_config["min_tls_version"]
    pre_warmed_instance_count   = local.site_config["pre_warmed_instance_count"]
    scm_ip_restriction          = local.site_config["scm_ip_restriction"]
    scm_type                    = local.site_config["scm_type"]
    scm_use_main_ip_restriction = local.site_config["scm_use_main_ip_restriction"]
    use_32_bit_worker_process   = local.site_config["use_32_bit_worker_process"]
    websockets_enabled          = local.site_config["websockets_enabled"]
    vnet_route_all_enabled      = local.site_config["vnet_route_all_enabled"]
    dynamic "ip_restriction" {
      for_each = local.site_config.ip_restrictions.ip_addresses
      iterator = ip_addresses
      content {
        ip_address = ip_addresses.value["ip_address"]
        name       = ip_addresses.value["rule_name"]
        priority   = ip_addresses.value["priority"]
        action     = ip_addresses.value["action"]
      }
    }
    dynamic "ip_restriction" {
      for_each = local.site_config.ip_restrictions.service_tags
      iterator = service_tags
      content {
        service_tag = service_tags.value["service_tag_name"]
        name        = service_tags.value["rule_name"]
        priority    = service_tags.value["priority"]
        action      = service_tags.value["action"]
      }
    }
    dynamic "ip_restriction" {
      for_each = local.site_config.ip_restrictions.subnet_ids
      iterator = subnet_ids
      content {
        virtual_network_subnet_id = subnet_ids.value["subnet_id"]
        name                      = subnet_ids.value["rule_name"]
        priority                  = subnet_ids.value["priority"]
        action                    = subnet_ids.value["action"]
      }
    }
  }

  identity {
    type         = length(var.identity_ids) == 0 ? "SystemAssigned" : "UserAssigned"
    identity_ids = length(var.identity_ids) == 0 ? null : var.identity_ids
  }

  lifecycle {
    ignore_changes = [
      os_type
    ]
  }
}