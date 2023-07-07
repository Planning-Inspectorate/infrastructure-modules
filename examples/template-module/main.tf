/**
* # terraform-modules
* 
* This directory contains code that is used as a template for new Hiscox Terraform modules.
* It is designed to support the following standards and conventions
*
* * Terraform configuration files (e.g. data.tf for terraform data elements, output.tf for output variables). Note that this template cannot cater for every kind of resource that may be described by Terraform. There is obviously some discretion on the part of the engineer to use meaningful names for these files.
* * Use of Invoke-Terraform on build agent
* * Local terraform deployments with native terraform commands and authentication to azure using az login (i.e. as yourself, which makes sense)
* * Tests folder, housing .tfavrs for CI
* * Use of constants.auto.tfvars for non-secret values that never change
* * Use of secrets.auto.tfvars for local-only secrets that are gitignored.
* * Build plan uses tf_provider_ARM_XXX variables passed to PSDeployTools
* * Use of terraform-docs as standard
* 
* ## How To Use
* 
* Include example code snippets:
*
* ### Example One
*
* ```terraform
* module "tempalte" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//template-module"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
* }
* ```
* 
* 1. Create a new module directory
* 1. Use the contents of this module as a base for all files in your new module
* 
* See wiki page for more information: https://hiscox.atlassian.net/wiki/spaces/TPC/pages/646709562
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// if you do not specify an existing resurce group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "${var.environment}-${var.application}-template-${var.location}"
  location = var.location
  tags     = local.tags
}


// Example useful stuff

// multiple blocks looping using type map(string)
# dynamic "custom_domain" {
#     for_each = var.custom_domain
#     content {
#       name          = custom_domain.value["name"]
#       use_subdomain = custom_domain.value["use_subdomain"]
#     }
#   }

// nested block looping for list(map(string)) types
# dynamic "backend_http_settings" {
#     for_each = [for bhs in var.backend_http_settings : {
#       name                  = bhs.name
#       cookie_based_affinity = bhs.cookie_based_affinity
#       port                  = bhs.port
#       protocol              = bhs.protocol
#       request_timeout       = bhs.request_timeout
#       probe_name            = bhs.probe_name
#     }]

#     content {
#       name                  = backend_http_settings.value.name
#       cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
#       port                  = backend_http_settings.value.port
#       protocol              = backend_http_settings.value.protocol
#       request_timeout       = backend_http_settings.value.request_timeout
#       probe_name            = backend_http_settings.value.probe_name
#       connection_draining {
#         enabled           = true
#         drain_timeout_sec = 60
#       }
#     }
#   }

# A note on outputs

# Normally you can output a resource ID with something like:

# output "pool_db_id" {
#   description = "Id of the pool database"
#   value       = azurerm_sql_database.pool_database.id
# }

# However if you're using a for_each loop to control !resource! creation (instead of count) your output needs to be converted ot the following:

# output "pool_db_data" {
#   description = "Map of the pool databases"
#   value       = azurerm_sql_database.pool_database
# }

# The for_each iterator uses maps and sets, when a resource has been iterated in this fashion (NOT dynamic block iteration) your output will instead be a map of maps:
# pool_db_data = {
#   "database1" = {
#     id = "guid"
#     somethin = "else"
#   }
#   "database2" = {
#     id = "guid"
#     somethin = "else"
#   }
# }

# The syntax for outputing the IDs of a resouce whehn using count is (as count outputs return a list type):

# output "pool_db_id" {
#   description = "Id of the pool database"
#   value       = azurerm_sql_database.pool_database[*].id
# }