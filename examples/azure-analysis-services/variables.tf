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

variable "sku" {
  description = "SKU for the Analysis Services Server. Possible values are: D1, B1, B2, S0, S1, S2, S4, S8, S9, S8v2 and S9v2"
}

variable "admin_users" {
  description = "List of email addresses of admin users"
  type        = list(string)
  default     = []
}

variable "enable_power_bi_service" {
  description = "Indicates if the Power BI service is allowed to access or not"
  default     = false
}

variable "ipv4_firewall_rules" {
  type        = list(map(string))
  description = <<-EOT
  "One or more ipv4_firewall_rule block(s) as defined below:
  [
    {
      name        = "myRule1"
      range_start = "210.117.252.0"
      range_end   = "210.117.252.255"
    }
  ]"
  EOT
  default     = []
}

variable "ipv4_firewall_rules_include_cicd_agents" {
  type        = bool
  description = "A boolean switch to allow for scenarios where the default set of cicd subnets (containing for example Bamboo/ADO agents) should not be added to the ipv4 firewall rules."
  default     = true
}
