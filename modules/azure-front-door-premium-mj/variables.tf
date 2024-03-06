# ---------------------------
# Frontdoor Profile Vars
# ---------------------------
# variable "azure" {
#   type = object({
#     resource_group_name = string
#     location            = optional(string)
#   })

#   description = "Where the resources will be deployed on"
# }

variable "name" {
  type        = string
  description = "The name of the Front Door profile. All associated resources' names will also be prefixed by this value"
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Region where it is hosted."
  type        = string
}

variable "sku_name" {
  description = "Specifies the SKU for this CDN FrontDoor Profile. Possible values include `Standard_AzureFrontDoor` and `Premium_AzureFrontDoor`."
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "response_timeout_seconds" {
  description = "Specifies the maximum response timeout in seconds. Possible values are between `16` and `240` seconds (inclusive)."
  type        = number
  default     = 120
}

# Where would we need this? something specific about each instance of FD
# variable "additional_tags" {
#   type        = map(string)
#   description = "Additional tags for the Front Door profile"
#   default     = {}
# }

# # undestand why we would need this variable if we already have 2 other vars for tags
# variable "additional_tags_all" {
#   type        = map(string)
#   description = "Additional tags for all resources deployed with this module"
#   default     = {}
# }

# -------------
# Endpoint Vars - Need to go through each value and decide if we need it?
#--------------
#

# variable "endpoints" {
#   description = "CDN FrontDoor Endpoints configurations."
#   type = map(object({
#     name                 = string
#     prefix               = optional(string)
#     custom_resource_name = optional(string)
#     enabled              = optional(bool, true)
#   }))
#   default = {}

# }

########### Potentially use this one
variable "endpoints" {
  description = "CDN FrontDoor Endpoints configurations."
  type = map(object({
    name                   = string
    origin_group_name      = optional(string)
    prefix                 = optional(string) # Is this needed?
    custom_resource_name   = optional(string) # Is this needed?
    enabled                = optional(bool, true)
    forwarding_protocol    = optional(string)
    patterns_to_match      = optional(map(string)) # Should this be a list? e.g. Match route, match something else if doesn't work...
    accepted_protocols     = optional(map(string)) # Should this be a list? e.g. HTTPS, then use HTTP...
    origin_path            = optional(string)
    https_redirect_enabled = optional(bool)
    link_to_default_domain = optional(bool)
    # custom_domains = optional(list(string))

    # additional_tags = optional(map(string))
  }))
  default = {}
}

variable "origin_groups" {
  description = "CDN FrontDoor Origin Groups configurations."
  type = map(object({
    name                                                      = string
    custom_resource_name                                      = optional(string)
    session_affinity_enabled                                  = optional(bool, true)
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = optional(number, 10)
    health_probe = optional(object({
      interval_in_seconds = number
      path                = string
      protocol            = string
      request_type        = string
    }))
    load_balancing = optional(object({
      additional_latency_in_milliseconds = optional(number, 50)
      sample_size                        = optional(number, 4)
      successful_samples_required        = optional(number, 3)
    }), {})
  }))
  default = {}
}

variable "origins" {
  description = "CDN FrontDoor Origins configurations."
  type = map(object({
    name                           = string
    custom_resource_name           = optional(string)
    origin_group_name              = string
    enabled                        = optional(bool, true)
    certificate_name_check_enabled = optional(bool, true)

    host_name          = string
    http_port          = optional(number, 80)
    https_port         = optional(number, 443)
    origin_host_header = optional(string)
    priority           = optional(number, 1)
    weight             = optional(number, 1)

    private_link = optional(object({
      request_message        = optional(string)
      target_type            = optional(string)
      location               = string
      private_link_target_id = string
    }))
  }))
  default = {}
}

# ------------------
# CDN FrontDoor Routes
# variable "routes" {
#   description = "CDN FrontDoor Routes configurations."
#   type = map(object({
#     name                 = string
#     custom_resource_name = optional(string)
#     enabled              = optional(bool, true)

#     endpoint_name     = string
#     origin_group_name = string
#     origins_names     = list(string)

#     forwarding_protocol = optional(string, "HttpsOnly")
#     patterns_to_match   = optional(list(string), ["/*"])
#     supported_protocols = optional(list(string), ["Http", "Https"])
#     cache = optional(object({
#       query_string_caching_behavior = optional(string, "IgnoreQueryString")
#       query_strings                 = optional(list(string))
#       compression_enabled           = optional(bool, false)
#       content_types_to_compress     = optional(list(string))
#     }))

#     custom_domains_names = optional(list(string), [])
#     origin_path          = optional(string, "/")
#     rule_sets_names      = optional(list(string), [])

#     https_redirect_enabled = optional(bool, true)
#     link_to_default_domain = optional(bool, true)
#   }))
#   default = []
# }
