/*
    Terraform configuration file defining variables
*/

variable "action_group_id" {
  type        = string
  description = "The id of the action group to assign monitor triggers"
}

variable "alert_definitions" {
  type        = list(map(string))
  description = "User-defined alert configurations to be merged with the default baseline"
  default     = []
}

variable "target_resource_group" {
  type        = string
  description = "Resource group that holds the resource you want to monitor"
}

variable "target_resource_name" {
  type        = string
  description = "Name of the resouerce you want to monitor"
}

variable "target_resource_id" {
  type        = string
  description = "ID of the resource you want to monitor"
}

variable "target_resource_type" {
  type        = string
  description = "THe Azure type of the resource you want to monitor"
}

variable "tags" {
  type        = map(string)
  description = "Map tags to be applied to resources"
  default     = {}
}