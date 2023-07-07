# azure-policy

This module is designed to allow for the creation of new policy definitions, and the assignment of these policies. This does not cover however policy initiative sets. Ensure your TFVARS contains the relevant JSON to define your policy and provide the relevant parameters to both the definition and the assignment.

For more insight on how to provide the JSON format please review https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_assignment. Keep in mind that any policy JSON blocks will need an empty line after the terminating code or an error will be received.

## Dependencies

Currently there are no dependencies for this module

### Example

The following provides an example of the call to this module, including the necessary variables with example values.
# The variable values can be set normally in a .tfvars file also if required

```terraform
module "policy" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-policy?ref=1.0.0"
  managementgroup = "dev"
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
```

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2, < 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_policy_assignment.policyassignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_assignment) | resource |
| [azurerm_policy_definition.policydefinition](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_managementgroup"></a> [managementgroup](#input\_managementgroup) | Management Group definition is stored against | `string` | n/a | yes |
| <a name="input_policy_assignment_name"></a> [policy\_assignment\_name](#input\_policy\_assignment\_name) | Name of policy assignment | `string` | n/a | yes |
| <a name="input_policy_assignment_params"></a> [policy\_assignment\_params](#input\_policy\_assignment\_params) | Parameter values for the policy assignment | `string` | n/a | yes |
| <a name="input_policy_assignment_scope"></a> [policy\_assignment\_scope](#input\_policy\_assignment\_scope) | Scope of policy assignment | `string` | n/a | yes |
| <a name="input_policy_definition_description"></a> [policy\_definition\_description](#input\_policy\_definition\_description) | Description of Policy Definition | `string` | n/a | yes |
| <a name="input_policy_definition_metadata"></a> [policy\_definition\_metadata](#input\_policy\_definition\_metadata) | Meta data for the policy definition | `string` | n/a | yes |
| <a name="input_policy_definition_mode"></a> [policy\_definition\_mode](#input\_policy\_definition\_mode) | Mode for Policy Definition | `string` | `"All"` | no |
| <a name="input_policy_definition_name"></a> [policy\_definition\_name](#input\_policy\_definition\_name) | Name for policy definition | `string` | n/a | yes |
| <a name="input_policy_definition_params"></a> [policy\_definition\_params](#input\_policy\_definition\_params) | Parameters for the policy definition | `string` | n/a | yes |
| <a name="input_policy_definition_rule"></a> [policy\_definition\_rule](#input\_policy\_definition\_rule) | Rule for the policy definition | `string` | n/a | yes |
| <a name="input_policy_definition_type"></a> [policy\_definition\_type](#input\_policy\_definition\_type) | Type for the policy definition | `string` | `"Custom"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_assignment_id"></a> [policy\_assignment\_id](#output\_policy\_assignment\_id) | ID of policy assignment |
| <a name="output_policy_definition_id"></a> [policy\_definition\_id](#output\_policy\_definition\_id) | ID of policy definition |
