variable "common_tags" {
  description = "The common resource tags for the project"
  type        = map(string)
}

variable "domain_name" {
  description = "Public domain name"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "frontend_endpoint" {
  description = "The endpoint for the frontend"
  type        = string
}

variable "location" {
  description = "The location the App Services are deployed to in slug format e.g. 'uk-south'"
  type        = string
}

variable "name" {
  description = "The name of the resource."
  type        = string
}

variable "sku_name" {
  description = "Specifies the SKU for this Front Door Profile."
  type        = string
}

variable "origin" {
  description = "CDN FrontDoor Origins configurations."
  type = map(object({
    name                           = string
    custom_resource_name           = optional(string)
    enabled                        = optional(bool, true)
    certificate_name_check_enabled = optional(bool, true)

    host_name          = string
    http_port          = optional(number, 80)
    https_port         = optional(number, 443)
    origin_host_header = optional(string)
    priority           = optional(number, 5)
    weight             = optional(number, 100)

    private_link = optional(object({
      request_message        = optional(string)
      target_type            = optional(string)
      location               = string
      private_link_target_id = string
    }))
  }))
  default = {}
}

variable "route" {
  description = "CDN FrontDoor Routes configurations."
  type = map(object({
    name                 = string
    custom_resource_name = optional(string)
    enabled              = optional(bool, true)


    forwarding_protocol = optional(string, "MatchRequest")
    patterns_to_match   = optional(list(string), ["/*"])
    supported_protocols = optional(list(string), ["Https"])
    cache = optional(object({
      query_string_caching_behavior = optional(string, "IgnoreQueryString")
      query_strings                 = optional(list(string))
      compression_enabled           = optional(bool, false)
      content_types_to_compress     = optional(list(string))
    }))

    custom_domains_names = optional(list(string), [])
    origin_path          = optional(string)
    rule_sets_names      = optional(list(string), [])

    https_redirect_enabled = optional(bool, true)
    link_to_default_domain = optional(bool, true)
  }))
}
