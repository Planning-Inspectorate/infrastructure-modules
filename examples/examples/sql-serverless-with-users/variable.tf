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

variable "allow_subnet_ids" {
  type        = map(string)
  description = "A map of subnet IDs allow access to the DBs. e.g: { bamboo='...', platform='...' }"
  default     = {}
}

variable "standalone_dbs" {
  type        = map(map(string))
  description = "Map of maps containing config for standalone databases e.g: { db1={ max_size = 32, edition='Premium', performance_level='P1'}, db2={...} ]"
  default     = {}
}

variable "database_users" {
  type = list(map(any))
  description = "List of map of strings detailng contained users to be created in Azure SQL DBs. The map structure is dependant on the user type (see module)"
  default = []
}