# azure-role-assignment

Provisions required RBAC role assignments on resource groups in Azure.

Resource groups can already exist or be created dynamically by the module.
If the resource groups already exist, you must still supply values for location and tags - simply set these to "null", however.
This is due to a limitation in Terraform's definition of custom object types at present.

## Dependencies

## Resources

* Optionally, Azure resource group(s) if specified
* Azure RBAC Role Assignments as defined in tfvars

## Example

The following provides an example of the call to this module, including the necessary variable definitions with example default values.

```terraform
variable "resource_groups" {
   default = ["existing-resource-group"]
}

variable "assignments" {
    default = [
        {
            role = "owner"
            user = "admin.user@domain.com"
        },
        {
            role = "reader"
            group = "Normal users"
        },
        {
            role = "contributor"
            id = "xxxxx-xxxxx-xxxxx-xxxxx-xxxxx"
        },
        {
            role = "custom role name"
            service_principal = "My Service Prinicpal Name"
        }
    ]
}
```

The above values can be set normally in a .tfvars file also if required

```terraform
module "rbac" {
  source               = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-role-assignment"
  assignments          = var.assignments
  resource_groups      = var.resource_groups
}
```

>NB When passing group or service principal names, bear in mind that they are case-sensitive for Terraforn to perform
lookups against Azure AD

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 1.4, < 2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2, < 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 1.4, < 2 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.ra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azuread_group.group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_service_principal.sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azuread_user.user](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assignments"></a> [assignments](#input\_assignments) | List of maps defining assignments to apply to each resource group in var.resource\_group\_namesin format of a list of maps containing two fields, <role> (mandatory) and one of <user/group/service\_principal/id>, allowing you to specify by name OR object ID | `list(map(string))` | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | List of resource group(s) to apply role assigment to. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_assignments"></a> [assignments](#output\_assignments) | All IDs etc of created assignments |
