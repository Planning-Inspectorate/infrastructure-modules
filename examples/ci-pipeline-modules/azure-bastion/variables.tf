variable "vnet" {
  description = "The virtual network where bastion is provisoned"
}

variable "vnet_resource_group_name" {
  description = "The name of the resource group housing the virtual network"
}

variable "subnet_cidr" {
  description = "The subnet CIDR size of bastion subnet. Minimum CIDR /27"
  default     = ["AzureBastionSubnet"]
}

variable "location" {
  description = "Azure region to deploy to"
}

variable "environment" {
  description = "Used to construct the resource group name"
}

variable "application" {
  description = "Name of the application"
  default     = "devops"
}

variable "service_name_environment" {
  description = "Used to construct the name of the bastion resource. eg 'dev'/'prod'"
}

variable "service_name_business" {
  description = "Used to construct the name of the bastion resource. eg 'us'"
}

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
