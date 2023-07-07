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

variable "node_size" {
  type        = string
  description = "Size of the nodes"
  default     = "Standard_D2_v2"
}

variable "number_of_nodes" {
  type        = number
  description = "Number of managed integration runtime nodes. Max 10."
  default     = 1
}

variable "max_parallelism" {
  type        = number
  description = "Maximum number of parallel executions per node. Max 16"
  default     = 1
}

variable "edition" {
  type        = string
  description = "Runtime edition. Standard or Enterprise"
  default     = "Enterprise"
}

variable "license_type" {
  type        = string
  description = "LicenseIncluded or BasePrice"
  default     = "BasePrice"
}

variable "catalog_info" {
  type        = list(map(string))
  description = <<-EOT
  "A list of maps containing catalog config. Format:
    [{
      server_endpoint = ""
      administrator_login = ""
	  administrator_password = ""
	  pricing_tier = ""
    }]"
  EOT
  default     = []
  # Cannot be marked sensitive as used in for_each
}

variable "vnet_integration" {
  type        = list(map(string))
  description = <<-EOT
  "A list of maps containing the vnet ID and the subnet name where nodes will be deployed to. Format:
    [{
      vnet_id = "the vnet id"
      subnet_name = "the subnet name"
    }]"
  EOT
  default     = []
}

variable "linked_sql_server" {
  type        = map(map(string))
  description = <<-EOT
  "Sql Server instances to be configured as linked services. Format:
    {
      friendly_name = {
		  connection_string = ""
		  runtime_name = ""
	  }
    }"
  EOT
  default     = {}
  # Cannot be marked sensitive as used in for_each
}

variable "linked_blob_storage" {
  type        = map(map(string))
  description = <<-EOT
  "Blob storage instances to be configured as linked services. Format:
    {
      friendly_name = {
		  connection_string = ""
	  }
    }"
  EOT
  default     = {}
  # Cannot be marked sensitive as used in for_each
}

variable "linked_file_storage" {
  type        = map(map(string))
  description = <<-EOT
  "File storage instances to be configured as linked services. Format:
    {
      friendly_name = {
		  connection_string = ""
	  }
    }"
  EOT
  default     = {}
  # Cannot be marked sensitive as used in for_each
}

variable "linked_key_vault" {
  type        = map(map(string))
  description = <<-EOT
  "Key vault instances to be configured as linked services. Format:
    {
      friendly_name = {
		  key_vault_id = ""
		  description = ""
	  }
    }"
  EOT
  default     = {}
  # Cannot be marked sensitive as used in for_each
}

variable "vsts_configuration" {
  type        = map(string)
  description = <<-EOT
  "Configuration to link ADF to git repo. Format:
    {
      account_name    = ""
      branch_name     = ""
      project_name    = ""
      repository_name = ""
      root_folder     = ""
      tenant_id       = ""
    }
  "
  EOT
  default     = null
}


# variable "sql_server_name" {
#   description = "Name of the SQL instance to be used in linked services and integration runtime"
# }

# variable "sql_admin_ad_user" {
#   description = "The name of an AD account that is an admin user on the sql server"
# }

# variable "sql_admin_ad_password" {
#   description = "The password of the AD account user"
# }

# variable "sql_storage_secret_name" {
#   description = "The name of the SQL Storage secret in KeyVault"
# }

# variable "keyvault_name" {
#   description = "Name of keyvault for the linked service"
# }

# variable "keyvault_uri" {
#   description = "URI of keyvault for the linked service"
# }

# variable "oms_workspace_id" {
#   description = "OMS workspace ID"
# }

# variable "ssis_integration_runtimes" {
#   type    = map(map(string))
#   default = {}
# }

# variable "azure_integration_runtimes" {
#   type    = map(map(string))
#   default = {}
# }

# variable "self_hosted_integration_runtimes" {
#   default = {}
#   type    = map(map(string))
# }

# variable "databases" {
#   type    = map(map(string))
#   default = {}
# }
