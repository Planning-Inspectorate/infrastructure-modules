/**
* # app-service-plan
*
* Creates an Azure App Service (WebApp)
*
*
* ## How To Use
*
* ### Dotnet App Service 
*
* ```terraform
* module "as_dotnet" {
*   source              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-app-service"
*   app_service_plan_id = module.asp.id
*   environment         = var.environment
*   application         = var.application
*   location            = var.location
* }
* ```
*
* ### Java App Service 
*
* ```terraform
* module "as_java" {
*   source              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-app-service"
*   app_service_plan_id = module.asp.id
*   environment         = var.environment
*   application         = var.application
*   location            = var.location
*   site_config         = {
*     java_version      = "11"
*   }
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
  name     = "${var.environment}-${var.application}-appservice-${var.location}"
  location = var.location
  tags     = local.tags
}

// app service names must be globally unique so we append a random string
resource "random_string" "rnd" {
  length  = 4
  special = false
  upper   = false
}
resource "azurerm_app_service" "as" {
  name                = "${var.environment}-${var.application}-${random_string.rnd.result}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  app_service_plan_id = var.app_service_plan_id
  https_only          = true

  site_config {
    always_on        = local.site_config["always_on"]
    app_command_line = local.site_config["app_command_line"]
    cors {
      allowed_origins     = local.site_config.cors["allowed_origins"]
      support_credentials = local.site_config.cors["support_credentials"]
    }
    default_documents         = local.site_config["default_documents"]
    dotnet_framework_version  = local.site_config["dotnet_framework_version"]
    ftps_state                = local.site_config["ftps_state"] == "AllAllowed" ? "FtpsOnly" : local.site_config["ftps_state"]
    health_check_path         = local.site_config["health_check_path"]
    http2_enabled             = local.site_config["http2_enabled"]
    java_version              = local.site_config["java_version"]
    java_container            = local.site_config["java_container"]
    java_container_version    = local.site_config["java_container_version"]
    local_mysql_enabled       = local.site_config["local_mysql_enabled"]
    linux_fx_version          = local.site_config["linux_fx_version"]
    windows_fx_version        = local.site_config["windows_fx_version"]
    managed_pipeline_mode     = local.site_config["managed_pipeline_mode"]
    min_tls_version           = local.site_config["min_tls_version"] == "1.0" || local.site_config["min_tls_version"] == "1.1" ? "1.2" : local.site_config["min_tls_version"]
    php_version               = local.site_config["php_version"]
    python_version            = local.site_config["python_version"]
    remote_debugging_enabled  = local.site_config["remote_debugging_enabled"]
    remote_debugging_version  = local.site_config["remote_debugging_version"]
    scm_type                  = local.site_config["scm_type"]
    use_32_bit_worker_process = local.site_config["use_32_bit_worker_process"]
    websockets_enabled        = local.site_config["websockets_enabled"]
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

  app_settings = var.app_settings

  identity {
    type         = length(var.identity_ids) == 0 ? "SystemAssigned" : "UserAssigned"
    identity_ids = length(var.identity_ids) == 0 ? null : var.identity_ids
  }

  auth_settings {
    enabled = false
  }

  dynamic "storage_account" {
    for_each = var.storage_account
    content {
      name         = storage_account.value["name"]
      type         = storage_account.value["type"]
      account_name = storage_account.value["account_name"]
      share_name   = storage_account.value["share_name"]
      access_key   = sensitive(storage_account.value["access_key"])
      mount_path   = storage_account.value["mount_path"]
    }
  }

  # backup {
  #   name = var.backup["name"]
  #   enabled = var.backup["enabled"]
  #   storage_account_url = var.backup["url"]
  #   schedule {
  #     frequency_interval = 
  #     frequency_unit = 
  #     keep_at_least_one_backup = 
  #     retention_period_in_days = 
  #     start_time = 
  #   }
  # }

  # dynamic "connection_string" {
  #   content {
  #     name  = "Database"
  #     type  = "SQLServer"
  #     value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  #   }
  # }
  # client_affinity_enbaled
  # client_cert_enabled
  # enabled
  # https_only = true
  # logs
  tags = local.tags
}