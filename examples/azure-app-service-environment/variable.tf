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

variable "subnet_id" {
  type        = string
  description = "ID of the subnet this ASE should be connected to. Note your subnet must be /24 or larger"
}

variable "pricing_tier" {
  type        = string
  description = "Pricing tier, allowed vlaues are I1, I2 and I3"
  default     = "I1"
}

variable "front_end_scale_factor" {
  type        = number
  description = "Scale factor, allowed values between 5 and 15"
  default     = 15
}

variable "internal_load_balancing_mode" {
  type        = string
  description = "Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. Possible values are None, Web, Publishing and combined value 'Web, Publishing'"
  default     = "None"
}

variable "allowed_user_ip_cidrs" {
  type        = list(string)
  description = "List of CIDRs to be used for egress traffic. This should point towards a firewall or proxy, note you'll most likely need to include a route table by enabling this"
  default     = null
}

variable "cluster_setting" {
  type        = map(string)
  description = "Map where keys are the name of a cluster setting and the value is the value of that particular setting"
  default = {
    "DisableTls1.0" = "1"
  }
}