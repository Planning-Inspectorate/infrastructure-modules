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

variable "log_analytics_resource_group" {
  type        = string
  description = "Resource group that contains a log analytics workspace"
}

variable "log_analytics_name" {
  type        = string
  description = "Name of the log analytics workspace"
}

variable "key_vault_name" {
  type        = string
  description = "Name of the key vault, used to retrieve the password of the AD SQL account"
}

variable "key_vault_rg" {
  type        = string
  description = "Resource group that contains key vault"
}

variable "allow_subnet_ids" {
  type        = map(string)
  description = "A map of subnet IDs allow access to the DBs. e.g: { bamboo='...', platform='...' }"
  default     = {}
}

variable "pool_dbs" {
  type        = map(map(string))
  description = "Map of maps containing config for elastic pool databases e.g: { pooldb1={ max_size = 32, edition='Premium', performance_level='P1'}, pooldb2={...} ]"
  default     = {}
}

variable "elastic_pool_sku" {
  description = "SKU for the pool {name, tier, family, capacity}"
  type        = map(string)
  default = {
    name     = "BC_Gen5"
    tier     = "BusinessCritical"
    family   = "Gen5"
    capacity = 4
  }
}

variable "elastic_pool_capacity" {
  description = "The scale up/out capacity of the elastic pool, representing server's compute units (vCore-based or DTU-based) N.B. Overrides the capacity set in elastic pool sku"
  default     = 4
}

variable "elastic_pool_max_size_gb" {
  description = "The max data size of the elastic pool in gigabytes"
  default     = 256
}

variable "ad_sql_service_account" {
  description = "The usename of the Service AD Account pre-created by AD team, as an example svc_(environment_code)_(application)@hiscox.com"
}

variable "sql_server_ads_email_notifications" {
  type        = list(string)
  description = "Space seperated string of email addresses to receieve alerts"
}