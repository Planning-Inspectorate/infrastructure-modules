variable "resource_groups" {
  type        = list(string)
  description = "List of resource group(s) to apply role assigment to."
}

variable "assignments" {
  type        = list(map(string))
  description = "List of maps defining assignments to apply to each resource group in var.resource_group_namesin format of a list of maps containing two fields, <role> (mandatory) and one of <user/group/service_principal/id>, allowing you to specify by name OR object ID"
}
