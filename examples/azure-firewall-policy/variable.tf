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
  description = "The resource group to deploy the Azure Firewall Policy into. Must be next to the Firewall if attached"
}

variable "sku" {
  type        = string
  description = "The sku of the firewall policy"
  default     = "Standard"
}

variable "base_policy_id" {
  type        = string
  description = "The ID of a firewall policy which will be used as a baseline from which this policy will inherit"
  default     = null
}

variable "rule_collection_priority" {
  type        = number
  description = "The priority of the rule collection"
  default     = 500
}

variable "application_rules" {
  description = <<-EOT
  "A map of application rules where the key is the priority. Priority, name and rule names must be unique across nat, application and network rules. Format of:
  300 = {
    name = "test1"
    action = "Deny"
    rules = {
      a_rule_name1 = {
        source_addresses = []
        source_ip_groups = []
        destination_fqdns =[]
        destination_fqdn_tags = []
        rule_protocols = {
          Https = 443
        }
      }
    }
  }
  "
  EOT
  default     = {}
}

variable "network_rules" {
  description = <<-EOT
  "A map of network rules where the key is the priority. Priority, name and rule names must be unique across nat, application and network rules. Format of:
  200 = {
    name = "test2"
    action = "Deny"
    rules = {
      a_rule_name2 = {
        source_addresses = []
        source_ip_groups = []
        destination_addresses =[]
        destination_ip_groups = []
		destination_fqdns = []
		destination_ports = []
        protocols = []
      }
    }
  }
  "
  EOT
  default     = {}
}

variable "nat_rules" {
  description = <<-EOT
  "A map of nat rules where the key is the priority. Priority and name must be unique across nat, application and network rules. Note: if invalid attachment to firewall will fail. Format of:
  100 = {
    name = "test3"
    action = "Dnat"
	rule_name = "example"
    rule_source_addresses = []
    rule_source_ip_groups = []
    rule_destination_address = "x.x.x.x"
    rule_destination_ports = []
    rule_protocols = []
	rule_translated_address = "x.x.x.x"
	rule_translated_port = 8443
  }
  "
  EOT
  default     = {}
}