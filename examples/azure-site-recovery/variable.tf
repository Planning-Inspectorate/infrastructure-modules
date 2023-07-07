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
  description = "The region primary resources will be deployed to"
  default     = "northeurope"
}

variable "dr_location" {
  type        = string
  description = "The region DR resources will be deployed to"
  default     = "westeurope"
}

variable "tags" {
  type        = map(string)
  description = "List of tags to be applied to resources"
  default     = {}
}

variable "resource_group_name_primary" {
  type        = string
  description = "The resource group containing primary resources into. If not specified one will be created for you with name like: environment-application-location"
}

variable "source_vm_metadata" {
  type = list(object({
    disk_ids = list(string)
    hostname = string
    nic      = list(string)
    id       = string
  }))
  description = <<EOF
  Metadata about the source VMs which should be included in the site recovery replication.
  vm_metadata = [
    {
      disk_ids = [
      "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/production-cyberark-northeurope/providers/Microsoft.Compute/disks/pr01022enmaq-00-os",
      ]
      hostname = "pr01022enmaq-00"
      id = "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/production-cyberark-northeurope/providers/Microsoft.Compute/virtualMachines/pr01022enmaq-00"
      nic      = [
        "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/production-cyberark-northeurope/providers/Microsoft.Network/networkInterfaces/pr01022enmaq-00",
      ]
    },
    {   
      disk_ids = [
        "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/production-cyberark-northeurope/providers/Microsoft.Compute/disks/pr01022enmaq-01-os",
      ]
      hostname = "pr01022enmaq-01"
      id = "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/production-cyberark-northeurope/providers/Microsoft.Compute/virtualMachines/pr01022enmaq-01"
      nic      = [
        "/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/production-cyberark-northeurope/providers/Microsoft.Network/networkInterfaces/pr01022enmaq-01",
      ]
    }
   
EOF
}

variable "source_disk_type" {
  type        = string
  description = "Type of disk used by source VM"
  default     = "Premium_LRS"
}

variable "target_subnet_name" {
  type        = string
  description = "Name of subnet to be used in DR location"
}

variable "target_vnet_name" {
  type        = string
  description = "Name of vnet to be used in DR location"
}

variable "target_vnet_resource_group" {
  type        = string
  description = "Name of resource group containing vnet to be used in DR location"
}

variable "asr_vault_name" {
  type        = string
  description = "Name of the ASR Vault to deploy replicated VM in to"
}

variable "asr_vault_rg" {
  type        = string
  description = "The resource group containing the Site Recovery vault to be used for VM replication"
}

variable "asr_primary_fabric_name" {
  type        = string
  description = "Name of the primary ASR fabric to use with replicated VM"
}

variable "asr_secondary_fabric_name" {
  type        = string
  description = "Name of the secondary ASR fabric to use with replicated VM"
}

variable "asr_primary_protection_container_name" {
  type        = string
  description = "Name of the primary ASR protection container to use with replicated VM"
}

variable "asr_secondary_protection_container_name" {
  type        = string
  description = "Name of the secondary ASR protection container to use with replicated VM"
}

variable "asr_policy_name" {
  type        = string
  description = "Name of the ASR policy to use with replicated VM"
}

variable "cache_storage_account_rg" {
  type        = string
  description = "Name of the RG containing the storage account to use as a cache within the primary site."
}

variable "cache_storage_account_name" {
  type        = string
  description = "Name of the storage account to use as a cache within the primary site. VM changes are cached within the storage account if replication is ever disrupted."
}