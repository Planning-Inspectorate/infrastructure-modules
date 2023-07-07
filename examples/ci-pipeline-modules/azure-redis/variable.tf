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

variable "sku_name" {
  type        = string
  description = "Tier required : Basic/Standard "
  default     = "Standard"
}

variable "capacity" {
  type        = number
  description = "The size of the Redis cache to deploy"
  default     = 2
}

variable "redis_firewall_rules" {
  type        = map(map(string))
  description = <<-EOT
  "Map of maps Redis firewall rules containing start and end IPs. Names must be alphanumeric only. Example format:
  name1 = {
    start_ip                  = "1.2.3.5"
    end_ip                    = "1.2.3.10"
  }
  name2 = {
    start_ip                  = "2.0.0.1"
    end_ip                    = "2.0.1.0"
  }"
  EOT
  default     = {}
}

