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

variable "ip_rules" {
  type        = list(map(string))
  description = <<-EOT
  "CIDRs and actions for network access i.e [{action = "Allow" ip_range = "127.0.0.1"}]
  EOT
  default     = []
}
