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

variable "sku" {
  type        = string
  description = "The sku to use for the Databricks Workspace. Possible values are standard, premium, or trial. Changing this forces a new resource to be created"
  default     = "standard"
}

variable "spark_version" {
  type        = string
  description = "Runtime version of the cluster. A list of available Spark versions can be retrieved by using the Runtime Versions API call or databricks clusters spark-versions CLI command. It is advised to use Cluster Policies to restrict list of versions for simplicity, while maintaining enough of control"
}

variable "node_type_id" {
  type        = string
  description = "Any supported databricks_node_type id"
}

variable "autotermination_minutes" {
  type        = number
  description = "Automatically terminates the cluster after it is inactive for this time in minutes. If not set, this cluster will not be automatically terminated. If specified, the threshold must be between 10 and 10000 minutes. You can also set this value to 0 to explicitly disable automatic termination"
}

variable "autoscale" {
  type        = map(string)
  default     = null
  description = <<-EOT
  "The autoscale parameter block. Contains the minimum number of workers to which the cluster can scale down when underutilized and maximum number of workers to which the cluster can scale up when overloaded. max_workers must be strictly greater than min_workers.
  autoscale = {
    autoscale_min_workers     = "min_workers"
    autoscale_max_workers     = "max_workers"
  }"
  EOT
}
