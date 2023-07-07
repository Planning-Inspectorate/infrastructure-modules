/*
    Terraform configuration file defining variables
*/

variable "resource_group_name" {
  type        = string
  description = "The target Resource Group the Network Security Groups exists in"
}

variable "network_security_group_name" {
  type        = string
  description = "The target Network Security Group"
}
