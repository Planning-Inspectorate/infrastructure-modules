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

variable "postgresql_database" {
  type        = list(map(string))
  description = <<-EOT
  "List of PostgreSQL databases, each map must contain a name field. Optional parameters that can be overriden (defaults can be found under locals.tf):
  {
    charset
    collation
  }"
  EOT
}
