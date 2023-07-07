/*
    Terraform configuration file defining variables
*/
variable "environment" {
  type        = string
  description = "The environment name. Used as a tag and in naming the resource group"
}

variable "name" {
  type        = string
  description = "The name to associate with load balancer instead of default '<env>-<application>-lb-<location>' scheme"
  default     = ""
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

variable "sku" {
  type        = string
  description = "The LB sku to use. Defaults to 'Standard'"
  default     = "Standard"
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

variable "frontend_ip_configuration" {
  type = list(object({
    name                          = string
    subnet_id                     = string
    private_ip_address            = string
    private_ip_address_allocation = string
    private_ip_address_version    = string
    public_ip_address_id          = string
    public_ip_prefix_id           = string
    zones                         = list(string)
  }))
  description = <<-EOT
"For example:
frontend_ip_configuration = [{
  name                          = "frontend"
  subnet_id                     = module.subnet.subnet_id
  private_ip_address            = null
  private_ip_address_allocation = "Dynamic"
  private_ip_address_version    = "IPv4"
  public_ip_address_id          = null
  public_ip_prefix_id           = null
  zones                         = null
}]"
EOT
  default     = []
}

variable "probes" {
  type = map(object({
    port                = number
    protocol            = string
    request_path        = string
    interval_in_seconds = number
    number_of_probes    = number
  }))
  description = <<-EOT
"List of probes, can only be set if a frontend configuration has been set. The map key is the name of the probe. For Example:
  probes = {
    probe1 = {
      port = 22
      protocol = "Tcp"
      request_path = null
      interval_in_seconds = 5
      number_of_probes = 2
}}"
EOT
  default     = {}
}

variable "backend_pool_names" {
  type        = list(string)
  description = "List of names for the backend pools"
  default     = []
}

variable "load_balancer_rules" {
  type = map(object({
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number
    frontend_ip_configuration_name = string
    backend_address_pool_name      = string
    probe_name                     = string
    enable_floating_ip             = bool
    idle_timeout_in_minutes        = number
    load_distribution              = string
    disable_outbound_snat          = bool
    enable_tcp_reset               = bool
  }))
  description = <<-EOT
"List of rules, can only be set if a frontend configuration has been set. The map key is the name of the rule. For Example:
  load_balancer_rules = {
    name1 = {
      protocol                       = "Tcp"
      frontend_port                  = 80
      backend_port                   = 8080
      frontend_ip_configuration_name = "frontend"
      backend_address_pool_name      = "defaultBackend"
      probe_name                     = "probe1"
      enable_floating_ip             = false
      idle_timeout_in_minutes        = 4
      load_distribution              = "Default"
      disable_outbound_snat          = false
      enable_tcp_reset               = false
}}"
EOT
  default     = {}
}