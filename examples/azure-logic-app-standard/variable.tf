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
  type        = map(string)
  description = "List of tags to be applied to resources"
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location"
  default     = ""
}

variable "app_service_plan_id" {
  type        = string
  description = "The ID of the App Service Plan to house this logic app"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account where the logic app will store its data"
}

variable "storage_account_access_key" {
  type        = string
  description = "The key the logic app will use to access storage"
}

variable "storage_account_share_name" {
  type        = string
  description = "The name of a custom share the logic app will use. If you specify this you should have the Storage module pre-create the share in advance!"
  default     = null
}

variable "client_affinity_enabled" {
  type        = bool
  description = "Should the logic app send session cookies"
  default     = true
}

variable "client_certificate_mode" {
  type        = string
  description = "Should incoming client have to send a certificate? Valid values are 'Optional' and 'Required'"
  default     = "Optional"
}

# variable "identity" {
#   type = object({
# 	  type = string
# 	  identity_ids = list(string)
#   })
#   description = "Specifies the identity type of the Logic App Possible values are SystemAssigned (where Azure will generate a Service Principal for you), UserAssigned where you can specify the Service Principal IDs in the identity_ids field, and SystemAssigned, UserAssigned which assigns both a system managed identity as well as the specified user assigned identities"
#   default = {
# 	type = "SystemAssigned"
# 	identity_ids = []
#   }
# }

variable "identity_ids" {
  type        = list(string)
  description = "List of service principal IDs if you want to use a User Assigned Identity over a System Assigned Identity"
  default     = []
}

variable "runtime_version" {
  type        = string
  description = "Runtime version of the Logic App, this will auto create the app_setting FUNCTIONS_EXTENSION_VERSION"
  default     = "~3"
}

variable "connection_string" {
  type        = list(map(string))
  description = "Single element list where the map contains a 'name', 'type' and 'value' fields"
  default     = []
}

variable "site_config_defaults" {
  type = object({
    always_on       = bool
    app_scale_limit = number
    cors = object({
      allowed_origins     = list(string)
      support_credentials = bool
    })
    dotnet_framework_version         = string
    elastic_instance_minimum         = number
    ftps_state                       = string
    health_check_path                = string
    http2_enabled                    = bool
    linux_fx_version                 = string
    min_tls_version                  = string
    pre_warmed_instance_count        = number
    runtime_scale_monitoring_enabled = bool
    use_32_bit_worker_process        = bool
    websockets_enabled               = bool
    ip_restrictions = object({
      ip_addresses = list(object({
        name       = string
        ip_address = string
        priority   = number
        action     = string
      }))
      service_tags = list(object({
        name             = string
        service_tag_name = string
        priority         = number
        action           = string
      }))
      subnet_ids = list(object({
        name      = string
        subnet_id = string
        priority  = number
        action    = string
      }))
    })
  })
  description = "A site config block for configuring the function"
  default = {
    always_on       = false
    app_scale_limit = null
    cors = {
      allowed_origins     = ["*"]
      support_credentials = false
    }
    dotnet_framework_version         = "v6.0"
    elastic_instance_minimum         = null
    ftps_state                       = "Disabled"
    health_check_path                = null
    http2_enabled                    = true
    linux_fx_version                 = null
    min_tls_version                  = "1.2"
    pre_warmed_instance_count        = null
    runtime_scale_monitoring_enabled = false
    use_32_bit_worker_process        = false
    websockets_enabled               = true
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
  description = "A map of key-value pairs for App Settings and custom values. There are a number of application settings that will be managed for you by this resource type and shouldn't be configured separately as part of the app_settings you specify. AzureWebJobsStorage is filled based on storage_account_name and storage_account_access_key. WEBSITE_CONTENTSHARE is detailed above. FUNCTIONS_EXTENSION_VERSION is filled based on version. APP_KIND is set to workflowApp and AzureFunctionsJobHost__extensionBundle__id and AzureFunctionsJobHost__extensionBundle__version are managed by use_extension_bundle. Important Default key pairs you MUST seed here: (\"WEBSITE_RUN_FROM_PACKAGE\" = \"\", \"FUNCTIONS_WORKER_RUNTIME\" = \"node\" (or python, etc), \"WEBSITE_NODE_DEFAULT_VERSION\" = \"10.14.1\", \"APPINSIGHTS_INSTRUMENTATIONKEY\" = \"\", etc."
  default     = {}
}