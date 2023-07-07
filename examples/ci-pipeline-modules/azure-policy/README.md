# azure-policy

CI pipeline for the azure-policy module

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azure-policy"></a> [azure-policy](#module\_azure-policy) | ../../azure-policy | n/a |

## Resources

No resources.

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

No outputs.
