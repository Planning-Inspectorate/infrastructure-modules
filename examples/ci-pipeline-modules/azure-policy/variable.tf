/*
    Terraform configuration file defining variables
*/

variable "policy_assignment_params" {
  type        = string
  description = "Parameter values for the policy assignment"
}

variable "policy_assignment_name" {
  type        = string
  description = "Name of policy assignment"
}

variable "policy_assignment_scope" {
  type        = string
  description = "Scope of policy assignment"
}

variable "policy_definition_name" {
  type        = string
  description = "Name for policy definition"
}

variable "policy_definition_mode" {
  type        = string
  description = "Mode for Policy Definition"
  default     = "All"
}

variable "policy_definition_description" {
  type        = string
  description = "Description of Policy Definition"
}

variable "policy_definition_params" {
  type        = string
  description = "Parameters for the policy definition"
}

variable "policy_definition_rule" {
  type        = string
  description = "Rule for the policy definition"
}

variable "policy_definition_type" {
  type        = string
  description = "Type for the policy definition"
  default     = "Custom"
}

variable "policy_definition_metadata" {
  type        = string
  description = "Meta data for the policy definition"
}

variable "managementgroup" {
  type        = string
  description = "Management Group definition is stored against"
}