variable "subnet_name" {
  type        = string
  description = "The name of the subnet to create"
}

variable "vnet_resource_group_name" {
  type        = string
  description = "The resource group that contians the vnet"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the vnet resources will be deployed to"
}

variable "address_prefixes" {
  type        = list(string)
  description = "The address prefix for the subnet"
}

variable "service_endpoints" {
  description = "List of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web"
  type        = list(string)
  default     = []
}

variable "delegation" {
  type = list(object({
    name                       = string
    service_delegation_name    = string
    service_delegation_actions = list(string)
  }))
  description = <<-EOT
  "The name of your delegation. 
  
  The service_delegation name field supports Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.Databricks/workspaces, Microsoft.DBforPostgreSQL/serversv2, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Logic/integrationServiceEnvironments, Microsoft.Netapp/volumes, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Web/hostingEnvironments and Microsoft.Web/serverFarms. 

  The service_delegation actions field is a list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include Microsoft.Network/networkinterfaces/*, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action.
  
  Example var:
  [
    {
      name = "delegation1"
      service_delegation_name = "Microsoft.Sql/managedInstances"
      service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  ]"
  EOT
  default     = []
}

variable "network_security_group_id" {
  type        = list(string)
  description = "The ID of an existing NSG to associate with the subnet if required"
  default     = []
}

variable "route_table_id" {
  type        = list(string)
  description = "The ID of an existing Route Table to associate with the subnet if required"
  default     = []
}

variable "enforce_private_link_endpoint_network_policies" {
  type        = bool
  description = "Disable network policies for the private link endpoint on the subnet. Conflicts with enforce_private_link_service_network_policies"
  default     = false
}

variable "enforce_private_link_service_network_policies" {
  type        = bool
  description = "Enable or Disable network policies for the private link service on the subnet. Conflicts with enforce_private_link_endpoint_network_policies"
  default     = false
}