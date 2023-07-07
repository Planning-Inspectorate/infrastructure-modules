Terraform Azure Role Assignment module
======================================

CI for Role Assignments

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rbac"></a> [rbac](#module\_rbac) | ../../azure-role-assignment | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assignments"></a> [assignments](#input\_assignments) | List of maps defining assignments to apply to each resource group in var.resource\_group\_namesin format of a list of maps containing two fields, <role> (mandatory) and one of <user/group/service\_principal/id>, allowing you to specify by name OR object ID | `list(map(string))` | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | List of resource group(s) to apply role assigment to. | `list(string)` | n/a | yes |

## Outputs

No outputs.
