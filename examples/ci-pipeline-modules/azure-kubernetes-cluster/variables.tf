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

variable "kubernetes_version" {
  description = "Version of Kubernetes to use, if set to null the latest recommended version is used"
  default     = "1.19.7"
}

variable "vm_count" {
  description = "The number of VMs in the cluster"
  default     = 3
}

variable "vm_size" {
  description = "The size of the VMs to provision"
  default     = "Standard_DS3_v2"
}

variable "os_disk_size_gb" {
  description = "Agent operating system disk size in Gb"
  default     = 128
}

variable "ssh_pub_key" {
  description = "Key for VM access. Never to be used"
}

variable "aks_in_rules" {
  description = "A Map of inbound NSG rules"
  type        = map(any)
  default     = {}
}

variable "aks_out_rules" {
  description = "A Map of outound NSG rules"
  type        = map(any)
  default     = {}
}

variable "node_autoscale_min_count" {
  description = "Minimum number of VMs in the autoscale pool"
  default     = 3
}

variable "node_autoscale_max_count" {
  description = "Maximum number of VMs in the autoscale pool"
  default     = 5
}

variable "max_pods" {
  description = "Maximum number of pods that can run on each agent"
  default     = 100
}

// does we need to whitelist the public ip of the master here too?
variable "api_server_authorized_ip_ranges" {
  description = "Restricts access to the master API"
  default     = ["10.0.0.0/8", "172.0.0.0/8", "109.71.86.32/27", "109.71.86.64/27"]
  type        = list(any)
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet AKS will assign node IPs from"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "The ID of a log analytics workspace for holding container logs"
}

variable "rbac_admin_group_object_ids" {
  type        = list(string)
  description = "List of AD Group object IDs which allow contained users admin access to API"
  default     = []
}
