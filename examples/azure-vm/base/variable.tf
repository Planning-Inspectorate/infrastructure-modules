variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy to"
}

variable "name" {
  type        = string
  description = "Name for all resources"
}

variable "location" {
  type        = string
  description = "Azure region to deploy to"
}

variable "load_balancer_backend_address_pools_ids" {
  type        = list(string)
  default     = []
  description = "List of string of the resource IDs for the load balancer backend address pools"
}

variable "subnet_id" {
  type = string
  description = "Target subnet to find IPs for NIC assigment"
}

variable "network_security_group_id" {
  type        = list(string)
  description = "Associate Network Security Group ID with VM"
  default     = []
}

variable "public_ip_address_allocation" {
  type        = string
  default     = "None"
  description = "Public IP to allocate to each NIC. Dynamic, Static or None"
}

variable "enable_accelerated_networking" {
  default = false
  type    = string
}

variable "enable_ip_forwarding" {
  default = false
  type    = string
}

variable "vm_count" {
  type = number
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "enable_backend_pool_association" {
  default     = false
  description = "Control variable for the backend address pool association in the NIC. Set to true if the VM will be attached to a Load Balancer."
}

variable "enable_https_traffic_only" {
  default = true
}

variable "existing_storage_account_name" {
    description = "This will make the module use and existing storage account"
    type        = string
    default     =  ""
}

variable "existing_storage_account_rg_name"{
    description = "This will make the module look for an existing storage account on this resource group"
    type        = string
    default     =  ""
}

variable "network_interface_ip_configuration_name" {
  type        = string
  default     = "Default"
  description = "Name for the IP Configuration attached to the Network Interface created for the Virtual Machine. If default value is not changed it will match the VM name."
}

variable "platform_fault_domain_count" {
  description = "Availability set platform fault domain count"
  type    = string
  default = "3"

}

variable "platform_update_domain_count" {
  description = "Availability set platform update domain count"
  type    = string
  default = "5"
}

variable "asg_name_override" {
  type        = bool
  description = "Used to force the application security group to use the name (false) or the resource_group_name (true). Values can be true/false"
  default = false
}

variable "environment" {
  type        = string
  description = "The environment name. Used as a tag and in naming the resource group"
}

variable "storage_soft_delete_retention_policy" {
  type        = bool
  description = "Is soft delete enabled for containers and blobs?"
  default     = false
}

variable "network_default_action" {
  type        = string
  description = "If a source IPs fails to match a rule should it be allowed for denied"
  default     = "Deny"
}

variable "network_rule_ips" {
  type        = list(string)
  description = "List of public IPs that are allowed to access the storage account. Private IPs in RFC1918 are not allowed here"
  default     = []
}

variable "network_rule_virtual_network_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs which are allowed to access the storage account"
  default     = []
}

variable "network_rule_virtual_network_subnet_ids_include_cicd_agents" {
  type        = bool
  description = "A boolean switch to allow for scenarios where the default set of cicd subnets (containing for example Bamboo/ADO agents) should not be added to the storage accounts network rules. An example would be a storage accounts used as a cloud witness for a windows failover cluster that exists outside of the paired regions of the cluster nodes"
  default     = true
}