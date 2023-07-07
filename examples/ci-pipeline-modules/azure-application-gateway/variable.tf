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

variable "resource_group_name" {
  type        = string
  description = "The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "List of tags to be applied to resources"
  default     = {}
}

variable "autoscale_max_capacity" {
  type        = number
  description = "Max size the Application Gateway can scale to. Must be larger than min (2)"
  default     = 3
}

variable "ciphers" {
  type        = list(string)
  description = "List of acceptable ciphers, this list has been signed off by Infosec"
  default = [
    "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
    "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
    "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA",
    "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA",
    "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256",
    "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384",
    "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
    "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
    "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA",
    "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA",
    "TLS_RSA_WITH_AES_256_GCM_SHA384",
    "TLS_RSA_WITH_AES_128_GCM_SHA256",
    "TLS_RSA_WITH_AES_256_CBC_SHA256",
    "TLS_RSA_WITH_AES_128_CBC_SHA256",
    "TLS_RSA_WITH_AES_256_CBC_SHA",
    "TLS_RSA_WITH_AES_128_CBC_SHA"
  ]
}

variable "sku_name" {
  type        = string
  description = "The 'model' to use. Can be: Standard_Medium, Standard_Large, Standard_V2, WAF_Medium, WAF_Large, WAF_V2"
  default     = "WAF_V2"
}

variable "sku_tier" {
  type        = string
  description = "The 'model' to use. Can be: Standard, Satndard_V2, WAF, WAF_V2"
  default     = "WAF_V2"
}

variable "waf_configuration_firewall_mode" {
  type        = string
  description = "Firewall mode. Dectection or Prevention"
  default     = "Prevention"
}

variable "exclusions" {
  type        = list(map(string))
  description = "Exceptions to be allowed through the WAF"
  default     = []
}

variable "disabled_rule_groups" {
  type = list(object({
    rule_group_name = list(string)
    rules           = list(string)
  }))
  description = "List of disabled OWASP rules"
  default     = []
}

variable "subnet_id" {
  type        = string
  description = "The size and location of the subnet to house the gateway. A /28 netmask is a good choice"
}

variable "backend_pool" { //TODO: allow IPs, code only allows fqdn
  type = list(object({
    name  = string
    fqdns = list(string)
  }))
  description = "List of backend pools to be created with fqdns or IPs, there must be at least one"
}

variable "http_listeners" {
  type        = list(map(string))
  description = "List of listeners, there must be at least one"
}

variable "probes" {
  type        = list(map(string))
  description = "List of probes"
  default     = null
}

variable "backend_http_settings" {
  type        = list(map(string))
  description = "List of backend settings, there must be at least one"
}

variable "request_routing_rules" {
  type        = list(map(string))
  description = "List of routing rules, there must be at least one"
}

# variable "keyvault_name" {
#   description = "Name of the key vault holding cert secrets"
# }

# variable "keyvault_rg_name" {
#   description = "Resource group name where the key vault resides"
# }

# variable "cert_password_secret" {
#   description = "Password to a certificates pfx file"
# }

# variable "cert_name" {
#   description = "The name of the certifcate as seen in the App Gateway"
# }

# variable "cert" {
#   description = "Path to the certificate pfx file"
# }

variable "redirections" {
  type        = list(map(string))
  description = "List of redirection blocks"
  default     = []
}