/**
* # azure-policy
* 
* CI pipeline for the azure-policy module
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "azure-policy" {
  source                        = "../../azure-policy"
  policy_definition_name        = var.policy_definition_name
  policy_definition_type        = var.policy_definition_type
  policy_definition_mode        = var.policy_definition_mode
  policy_definition_description = var.policy_definition_description
  managementgroup               = var.managementgroup
  policy_definition_metadata    = var.policy_definition_metadata
  policy_definition_rule        = var.policy_definition_rule
  policy_definition_params      = var.policy_definition_params
  policy_assignment_name        = var.policy_assignment_name
  policy_assignment_scope       = var.policy_assignment_scope
  policy_assignment_params      = var.policy_assignment_params
}