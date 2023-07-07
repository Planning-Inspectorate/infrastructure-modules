/**
* # azure-policy
*
* This module is designed to allow for the creation of new policy definitions, and the assignment of these policies. This does not cover however policy initiative sets. Ensure your TFVARS contains the relevant JSON to define your policy and provide the relevant parameters to both the definition and the assignment.
*
* For more insight on how to provide the JSON format please review https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_assignment. Keep in mind that any policy JSON blocks will need an empty line after the terminating code or an error will be received.
*
* ## Dependencies
*
* Currently there are no dependencies for this module
*
* ### Example
*
* The following provides an example of the call to this module, including the necessary variables with example values.
* # The variable values can be set normally in a .tfvars file also if required
*
* ```terraform
* module "policy" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-policy?ref=1.0.0"
*   managementgroup = "dev"
*   policy_definition_name        = var.policy_definition_name
*   policy_definition_type        = var.policy_definition_type
*   policy_definition_mode        = var.policy_definition_mode
*   policy_definition_description = var.policy_definition_description
*   managementgroup               = var.managementgroup
*   policy_definition_metadata    = var.policy_definition_metadata
*   policy_definition_rule        = var.policy_definition_rule
*   policy_definition_params      = var.policy_definition_params
*   policy_assignment_name        = var.policy_assignment_name
*   policy_assignment_scope       = var.policy_assignment_scope
*   policy_assignment_params      = var.policy_assignment_params
* }
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/


# Resource block for policy definition
resource "azurerm_policy_definition" "policydefinition" {
  name                  = var.policy_definition_name
  policy_type           = var.policy_definition_type
  mode                  = var.policy_definition_mode
  display_name          = var.policy_definition_name
  description           = var.policy_definition_description
  management_group_name = var.managementgroup
  metadata              = var.policy_definition_metadata
  policy_rule           = var.policy_definition_rule
  parameters            = var.policy_definition_params
}

# Resource block for policy assignment
resource "azurerm_policy_assignment" "policyassignment" {
  name                 = var.policy_assignment_name
  scope                = var.policy_assignment_scope
  policy_definition_id = azurerm_policy_definition.policydefinition.id
  display_name         = var.policy_assignment_name
  parameters           = var.policy_assignment_params
}