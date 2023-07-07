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

variable "failover_location" {
  type        = string
  description = "The region resources will fail over to"
  default     = "westeurope"
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

variable "kind" {
  type        = string
  description = "Kind of cosmosdb to create"
  default     = "GlobalDocumentDB"
}

variable "capabilities" {
  type        = list(string)
  description = "The capabilities which should be enabled for this Cosmos DB account. Possible values are EnableAggregationPipeline, EnableCassandra, EnableGremlin, EnableTable, MongoDBv3.4, and mongoEnableDocLevelTTL"
  default     = ["EnableTable"]
}

variable "ip_range_filter" {
  type        = string
  description = "Comma separated single-string of IPs/ranges that are allowed client IPs to access this account"
  default     = null
}

variable "consistency_level" {
  type        = string
  description = "Consistency can be Session, Eventual, Strong, BoundedStaleness, ConsistentPrefix"
  default     = "Session"
}

variable "auto_failover" {
  type        = bool
  description = "Should automatic failover be enabled"
  default     = true
}

variable "subnet_id" {
  type        = list(string)
  description = "The ID of the subnet access should be restricted to"
  default     = []
}