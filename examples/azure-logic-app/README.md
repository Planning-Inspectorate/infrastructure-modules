# azure-logic-app

Provisions a Logic App.

## How To Use

* Provide inputs by calling this as a sub-module and you're set
* If only the LogicApp resource is going to be built, omit optional parameter blocks

```HCL
module "azure_logic_app" {
  source            = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-logic-app"
  environment       = var.environment
  application       = var.application
  location          = var.location
  tags              = var.tags
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
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_logic_app_workflow.logicapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_workflow) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_integration_service_environment_id"></a> [integration\_service\_environment\_id](#input\_integration\_service\_environment\_id) | The ID of the ISE to associate this Logic App to for VNet integration | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_logic_app_integration_account_id"></a> [logic\_app\_integration\_account\_id](#input\_logic\_app\_integration\_account\_id) | ID of the integration account to be used for the ISE | `string` | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Key values of parameters, note these ones must also exist in the workflow\_parameters varaible | `map(string)` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_workflow_parameters"></a> [workflow\_parameters](#input\_workflow\_parameters) | Key values of parameters to be supplied to the logic app | `map(string)` | `null` | no |
| <a name="input_workflow_schema"></a> [workflow\_schema](#input\_workflow\_schema) | Schema to use | `string` | `"https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logicapp_ids"></a> [logicapp\_ids](#output\_logicapp\_ids) | Logic app IDs |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
