module "cdn_frontdoor" {
  source = "../"
  # version = "x.x.x" # What module version github tags to pull???

  name = "Front-Door-Standard-Test"

  resource_group_name = "rg-smiling-swine"
  location            = "uk-south"

  # stack               = var.stack

  # logs_destinations_ids = [
  #   module.logs.log_analytics_workspace_id,
  #   module.logs.logs_storage_account_id,
  # ]

  endpoints = {
    "endpoint" = {
      name = "test"
    },
    "endpoint-2" = {
      name = "test-2" # I don't understand this
    }
  }
}
# origin_groups = [
#   {
#     name = "contoso"
#     health_probe = {
#       interval_in_seconds = 250
#       path                = "/"
#       protocol            = "Https"
#       request_type        = "GET"
#     }
#     load_balancing = {
#       successful_samples_required = 1
#     }
#   },
#   {
#     name = "contoso2"
#     health_probe = {
#       interval_in_seconds = 250
#       path                = "/"
#       protocol            = "Https"
#       request_type        = "GET"
#     }
#   },
# ]

# origins = [
#   {
#     name                           = "web"
#     origin_group_name              = "contoso"
#     certificate_name_check_enabled = false
#     host_name                      = "www.contoso.com"
#   },
#   {
#     name                           = "azure"
#     origin_group_name              = "contoso2"
#     certificate_name_check_enabled = false
#     host_name                      = "azure.contoso.com"
#   },
# ]

# custom_domains = [{
#   name      = "www"
#   host_name = "www.contoso.com"
# }]

# routes = [
#   {
#     name                 = "route66"
#     endpoint_name        = "web"
#     origin_group_name    = "contoso"
#     origins_names        = ["web", "azure"]
#     forwarding_protocol  = "HttpsOnly"
#     patterns_to_match    = ["/*"]
#     supported_protocols  = ["Http", "Https"]
#     custom_domains_names = ["www"]
#     rule_sets_names      = ["my_rule_set", "my_rule_set2"]
#   },
#   {
#     name                = "route2"
#     endpoint_name       = "azure"
#     origin_group_name   = "contoso2"
#     origins_names       = ["web"]
#     forwarding_protocol = "HttpsOnly"
#     patterns_to_match   = ["/contoso"]
#     supported_protocols = ["Http", "Https"]
#     rule_sets_names     = ["my_rule_set", "my_rule_set2"]
#   },
# ]

# rule_sets = [
#   {
#     name                 = "my_rule_set"
#     custom_resource_name = "custom_rule"

#     rules = [{
#       name                 = "redirect"
#       custom_resource_name = "myrulename"
#       order                = 1
#       actions = {
#         response_header_actions = [
#           {
#             header_action = "Overwrite"
#             header_name   = "Access-Control-Allow-Origin"
#             value         = "https://www.foo.bar.fr"
#           },
#           {
#             header_action = "Overwrite"
#             header_name   = "Access-Control-Allow-Credentials"
#             value         = "true"
#           },
#           {
#             header_action = "Overwrite"
#             header_name   = "Access-Control-Allow-Headers"
#             value         = "Authorization, Content-Type, ocp-apim-subscription-key"
#           },
#           {
#             header_action = "Overwrite"
#             header_name   = "Access-Control-Allow-Methods"
#             value         = "POST,PUT,GET,DELETE,OPTIONS"
#           },
#         ]
#         url_rewrite_actions = [{
#           source_pattern = "/"
#           destination    = "/contoso"
#         }]
#       }
#       conditions = {
#         is_device_conditions = [{
#           operator     = "Equal"
#           match_values = ["Desktop"]
#         }]
#       }
#     }]
#   },
#   {
#     name                 = "my_rule_set2"
#     custom_resource_name = "custom_rule2"
#   },
# ]

# firewall_policies = [{
#   name                              = "test"
#   enabled                           = true
#   mode                              = "Prevention"
#   redirect_url                      = "https://www.contoso.com"
#   custom_block_response_status_code = 403
#   custom_block_response_body        = "PGh0bWw+CjxoZWFkZXI+PHRpdGxlPkhlbGxvPC90aXRsZT48L2hlYWRlcj4KPGJvZHk+CkhlbGxvIHdvcmxkCjwvYm9keT4KPC9odG1sPg=="

#   custom_rules = [
#     {
#       name                           = "Rule1"
#       enabled                        = true
#       priority                       = 1
#       rate_limit_duration_in_minutes = 1
#       rate_limit_threshold           = 10
#       type                           = "MatchRule"
#       action                         = "Block"
#       match_conditions = [{
#         match_variable     = "RemoteAddr"
#         operator           = "IPMatch"
#         negation_condition = false
#         match_values       = ["10.0.1.0/24", "10.0.0.0/24"]
#       }]
#     },
#     {
#       name                           = "Rule2"
#       enabled                        = true
#       priority                       = 2
#       rate_limit_duration_in_minutes = 1
#       rate_limit_threshold           = 10
#       type                           = "MatchRule"
#       action                         = "Block"
#       match_conditions = [
#         {
#           match_variable     = "RemoteAddr"
#           operator           = "IPMatch"
#           negation_condition = false
#           match_values       = ["192.168.1.0/24"]
#         },
#         {
#           match_variable     = "RequestHeader"
#           selector           = "UserAgent"
#           operator           = "Contains"
#           negation_condition = false
#           match_values       = ["windows"]
#           transforms         = ["Lowercase", "Trim"]
#         },
#       ]
#     },
#   ]

# managed_rules = [
#   {
#     type    = "DefaultRuleSet"
#     version = "1.0"
#     action  = "Log"
#     exclusions = [{
#       match_variable = "QueryStringArgNames"
#       operator       = "Equals"
#       selector       = "not_suspicious"
#     }]
#     overrides = [
#       {
#         rule_group_name = "PHP"
#         rules = [{
#           rule_id = "933100"
#           enabled = false
#           action  = "Block"
#         }]
#       },
#       {
#         rule_group_name = "SQLI"
#         exclusions = [{
#           match_variable = "QueryStringArgNames"
#           operator       = "Equals"
#           selector       = "really_not_suspicious"
#         }]
#         rules = [{
#           rule_id = "942200"
#           action  = "Block"
#           exclusions = [{
#             match_variable = "QueryStringArgNames"
#             operator       = "Equals"
#             selector       = "innocent"
#           }]
#         }]
#       },
#     ]
#   },
#   {
#     type    = "Microsoft_BotManagerRuleSet"
#     version = "1.0"
#     action  = "Log"
#   },
# ]
# }]

# security_policies = [{
#   name                 = "MySecurityPolicy"
#   custom_resource_name = "MyBetterNamedSecurityPolicy"
#   firewall_policy_name = "test"
#   patterns_to_match    = ["/*"]
#   custom_domain_names  = ["www"]
#   endpoint_names       = ["web", "azure"]
# }]

# extra_tags = {
#   foo = "bar"
# }
