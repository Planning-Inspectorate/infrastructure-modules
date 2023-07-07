# azure-self-hosted-integration-runtime

This directory contains code that is used as to create self-hosted integration runtimes in Azure Data Factory instances.
> NB It does *not* create a VM - this must be done separately. This is to enable this module to handle standalone/shared/linked SHIRs in a consistent fashion.

There is a simple example of calling module below, and a more detailed configuration example, showing
how to build a shared and a linked SHIR and incorporate the VM, in the `examples/self-hosted-integration-runtime` folder.

## How To Use

Note: the role assignment uses the output of a data type to assign a role. The `module "shir"` block will require a `depends_on` listing the sources which provide the data factory name and resource group. For example:

```terraform
depends_on [
  module.data_factory
]
```

```terraform
module "shir" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-self-hosted-integration-runtime"
  environment = "dev"
  application = "app"
  location    = "northeurope"
}
```

```terraform
module "linked_shir" {
  source                           = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-self-hosted-integration-runtime"
  environment                      = "my-env"
  application                      = "my-app"
  location                         = "my-location"
  data_factory_name                = "my-data-factory""
  data_factory_resource_group_name = "my-data-factroy-resource-group"
  linked_shir                      = {
    name                             = "shared-shir-name"
    data_factory_name                = "your-data-factory"
    data_factory_resource_group_name = "your-data-factory-resource-group"
  }
}
```

See wiki page for more information: https://hiscox.atlassian.net/wiki/spaces/TPC/pages/646709562

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
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_data_factory_integration_runtime_self_hosted.shir](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_self_hosted) | resource |
| [azurerm_role_assignment.linked_shir](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_data_factory.df](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/data_factory) | data source |
| [azurerm_data_factory.linked_df](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/data_factory) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [external_external.linked_shir_resource_id](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [template_file.linked_shir_resource_id](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_data_factory_name"></a> [data\_factory\_name](#input\_data\_factory\_name) | The data factory to deploy the SHIR into | `string` | `""` | no |
| <a name="input_data_factory_resource_group_name"></a> [data\_factory\_resource\_group\_name](#input\_data\_factory\_resource\_group\_name) | The resource group of the data factory to deploy the SHIR into | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_linked_shir"></a> [linked\_shir](#input\_linked\_shir) | The details of a shared SHIR from another ADF instance to be linked to this new SHIR | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_shir_name"></a> [shir\_name](#input\_shir\_name) | The name used for the SHIR in the Azure Data Factory | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_shir_auth_keys"></a> [shir\_auth\_keys](#output\_shir\_auth\_keys) | n/a |
| <a name="output_shir_id"></a> [shir\_id](#output\_shir\_id) | n/a |
| <a name="output_shir_name"></a> [shir\_name](#output\_shir\_name) | n/a |
