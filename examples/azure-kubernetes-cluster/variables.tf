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
  type        = string
  description = "Version of Kubernetes to use, if set to null the latest recommended version is used"
  default     = "1.21.7"
}

variable "vm_count" {
  type        = number
  description = "The number of VMs in the cluster"
  default     = 3
}

variable "vm_size" {
  type        = string
  description = "The size of the VMs to provision"
  default     = "Standard_DS3_v2"
}

variable "os_disk_size_gb" {
  type        = number
  description = "Agent operating system disk size in Gb"
  default     = 128
}

variable "ssh_pub_key" {
  type        = string
  description = "Key for VM access. Never to be used"
  sensitive   = true
}

variable "node_autoscale_min_count" {
  type        = number
  description = "Minimum number of VMs in the autoscale pool"
  default     = 3
}

variable "node_autoscale_max_count" {
  type        = number
  description = "Maximum number of VMs in the autoscale pool"
  default     = 5
}

variable "max_pods" {
  type        = number
  description = "Maximum number of pods that can run on each agent"
  default     = 100
}

// does we need to whitelist the public ip of the master here too?
variable "api_server_authorized_ip_ranges" {
  type        = list(string)
  description = "Restricts access to the master API"
  default     = ["10.0.0.0/8", "172.0.0.0/8", "109.71.86.32/27", "109.71.86.64/27"]
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

variable "automatic_channel_upgrade" {
  type        = string
  description = "Automatic upgrades of Kubernetes version. Possible values are 'patch', 'stable', 'rapid' and 'node-image'. We suggest 'patch' as that will only upgrade minor versions as opposed to 'stable' which upgrades major versions and could break API stability"
  default     = "patch"
}

variable "maintenance_allowed" {
  type = object({
    day   = string
    hours = list(string)
  })
  description = "The day and available hours which a mainitenance window will be in place thereby permitting automatic patching"
  default = {
    day   = "Sunday"
    hours = ["20", "21", "22", "23"]
  }
}

variable "auto_scaler_profile" {
  type = object({
    balance_similar_node_groups      = bool
    expander                         = string
    max_graceful_termination_sec     = number
    max_node_provisioning_time       = string
    max_unready_nodes                = number
    max_unready_percentage           = number
    new_pod_scale_up_delay           = string
    scale_down_delay_after_add       = string
    scale_down_delay_after_delete    = string
    scale_down_delay_after_failure   = string
    scan_interval                    = string
    scale_down_unneeded              = string
    scale_down_unready               = string
    scale_down_utilization_threshold = string
    skip_nodes_with_local_storage    = bool
    skip_nodes_with_system_pods      = bool
  })
  description = "Cluster scaling behaviour"
  default = {
    balance_similar_node_groups      = false
    expander                         = "random"
    max_graceful_termination_sec     = 600
    max_node_provisioning_time       = "15m"
    max_unready_nodes                = 3
    max_unready_percentage           = 45
    new_pod_scale_up_delay           = "10s"
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scale_down_delay_after_failure   = "3m"
    scan_interval                    = "10s"
    scale_down_unneeded              = "10m"
    scale_down_unready               = "20m"
    scale_down_utilization_threshold = "0.5"
    skip_nodes_with_local_storage    = true
    skip_nodes_with_system_pods      = true
  }
}