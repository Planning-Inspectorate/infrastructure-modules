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

variable "nsg_in_rules" {
  // do not specify the type here, it's a complex map
  description = <<-EOT
  "A Map of inbound NSG rules. Example format:
  azure-https = {
    access                      = "Allow"
    priority                    = 300
    protocol                    = "Tcp"
    source_port_ranges          = ["0-4000", "4777"]
    source_address_prefix       = "172.0.0.0/8"
    destination_port_ranges     = ["443", "8443"]
    destinaation_address_prefix = "*"
  }"
  EOT
  default     = {}
}

variable "nsg_out_rules" {
  // do not specify the type here, it's a complex map
  description = <<-EOT
  "A Map of outound NSG rules. Example format:
  azure-https = {
    access                       = "Allow"
    priority                     = 300
    protocol                     = "Tcp"
    source_port_range            = "*"
    source_address_prefix        = "172.0.0.0/8"
    destination_port_ranges      = ["443", "8443"]
    destination_address_prefixes = ["167.87.99.100"]
  }"
  EOT
  default     = {}
}