/*
    Terraform configuration file defining variables
*/
variable "environment" {
  type        = string
  description = "The environment name. Used as a tag and in naming the resource group"
}

variable "application" {
  type        = string
  description = "Name of the application"
}

variable "location" {
  type        = string
  description = "The region resources will be deployed to"
  default     = "northeurope"
}

variable "tags" {
  description = "List of tags to be applied to resources"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location"
  default     = ""
}

variable "app_service_plan_id" {
  description = "ID of the app service plan instance to host this app service. If unspecified one will be created for you"
  default     = null
}

variable "site_config_defaults" {
  type = object({
    always_on        = bool
    app_command_line = string
    cors = object({
      allowed_origins     = list(string)
      support_credentials = bool
    })
    default_documents         = list(string)
    dotnet_framework_version  = string
    ftps_state                = string
    health_check_path         = string
    http2_enabled             = bool
    java_version              = string
    java_container            = string
    java_container_version    = string
    local_mysql_enabled       = string
    linux_fx_version          = string
    windows_fx_version        = string
    managed_pipeline_mode     = string
    min_tls_version           = string
    php_version               = string
    python_version            = string
    remote_debugging_enabled  = bool
    remote_debugging_version  = string
    scm_type                  = string
    use_32_bit_worker_process = bool
    websockets_enabled        = bool
    ip_restrictions = object({
      ip_addresses = list(object({
        rule_name  = string
        ip_address = string
        priority   = number
        action     = string
      }))
      service_tags = list(object({
        rule_name        = string
        service_tag_name = string
        priority         = number
        action           = string
      }))
      subnet_ids = list(object({
        rule_name = string
        subnet_id = string
        priority  = number
        action    = string
      }))
    })
  })
  description = "A site config block for configuring blah"
  default = {
    always_on        = true
    app_command_line = null
    cors = {
      allowed_origins     = ["*"]
      support_credentials = false
    }
    default_documents         = null
    dotnet_framework_version  = "v4.0"
    ftps_state                = "Disabled"
    health_check_path         = null
    http2_enabled             = true
    java_version              = null
    java_container            = null
    java_container_version    = null
    local_mysql_enabled       = null
    linux_fx_version          = null
    windows_fx_version        = null
    managed_pipeline_mode     = "Integrated"
    min_tls_version           = "1.2"
    php_version               = null
    python_version            = null
    remote_debugging_enabled  = false
    remote_debugging_version  = null
    scm_type                  = "None"
    use_32_bit_worker_process = false
    websockets_enabled        = true
    ip_restrictions = {
      ip_addresses = []
      service_tags = []
      subnet_ids   = []
    }
  }
}

variable "site_config" {
  description = "Site config to override site_config_defaults. Object structure identical to site_config_defaults"
  default     = {}
}

variable "app_settings" {
  type        = map(string)
  description = "App service plan application settings"
  default     = {}
}

variable "identity_ids" {
  type        = list(string)
  description = "List of service principal IDs if you want to use a User Assigned Identity over a System Assigned Identity"
  default     = []
}

variable "storage_account" {
  type        = list(map(string))
  description = ""
  default     = []
}
