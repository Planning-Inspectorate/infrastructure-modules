# azure-data-factory

This directory stands up an Azure Data Factory instance.

## How To Use

### Plain Data Factory

```terraform
module "df" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-data-factory"
  environment = "dev"
  application = "app"
  location    = "northeurope"
 }
```

### DF With Linked Key Vault

```terraform
module "df" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-data-factory"
  environment = "dev"
  application = "app"
  location    = "northeurope"
  linked_key_vault = {
    devtestapp = {
      connection_string = ""
      key_vault_id = data.blah
      description = ""
    }
  }
}
```

### Data Factory with a Managed Integration Runtime

```terraform
module "df" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-data-factory"
  environment = "dev"
  application = "app"
  location    = "northeurope"
  vnet = [{
    vnet_id = data.blah
    subnet_name = var.subnet_name
  }]
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
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3, < 4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3, < 4 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_data_factory.df](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory) | resource |
| [azurerm_data_factory_integration_runtime_managed.irm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_managed) | resource |
| [azurerm_data_factory_linked_service_azure_blob_storage.blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_azure_blob_storage) | resource |
| [azurerm_data_factory_linked_service_azure_file_storage.file](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_azure_file_storage) | resource |
| [azurerm_data_factory_linked_service_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_key_vault) | resource |
| [azurerm_data_factory_linked_service_sql_server.sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_sql_server) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_string.rnd](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_catalog_info"></a> [catalog\_info](#input\_catalog\_info) | "A list of maps containing catalog config. Format:<br>  [{<br>    server\_endpoint = ""<br>    administrator\_login = ""<br> administrator\_password = ""<br> pricing\_tier = ""<br>  }]" | `list(map(string))` | `[]` | no |
| <a name="input_edition"></a> [edition](#input\_edition) | Runtime edition. Standard or Enterprise | `string` | `"Enterprise"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | LicenseIncluded or BasePrice | `string` | `"BasePrice"` | no |
| <a name="input_linked_blob_storage"></a> [linked\_blob\_storage](#input\_linked\_blob\_storage) | "Blob storage instances to be configured as linked services. Format:<br>  {<br>    friendly\_name = {<br>  connection\_string = ""<br> }<br>  }" | `map(map(string))` | `{}` | no |
| <a name="input_linked_file_storage"></a> [linked\_file\_storage](#input\_linked\_file\_storage) | "File storage instances to be configured as linked services. Format:<br>  {<br>    friendly\_name = {<br>  connection\_string = ""<br> }<br>  }" | `map(map(string))` | `{}` | no |
| <a name="input_linked_key_vault"></a> [linked\_key\_vault](#input\_linked\_key\_vault) | "Key vault instances to be configured as linked services. Format:<br>  {<br>    friendly\_name = {<br>  key\_vault\_id = ""<br>  description = ""<br> }<br>  }" | `map(map(string))` | `{}` | no |
| <a name="input_linked_sql_server"></a> [linked\_sql\_server](#input\_linked\_sql\_server) | "Sql Server instances to be configured as linked services. Format:<br>  {<br>    friendly\_name = {<br>  connection\_string = ""<br>  runtime\_name = ""<br> }<br>  }" | `map(map(string))` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_max_parallelism"></a> [max\_parallelism](#input\_max\_parallelism) | Maximum number of parallel executions per node. Max 16 | `number` | `1` | no |
| <a name="input_node_size"></a> [node\_size](#input\_node\_size) | Size of the nodes | `string` | `"Standard_D2_v2"` | no |
| <a name="input_number_of_nodes"></a> [number\_of\_nodes](#input\_number\_of\_nodes) | Number of managed integration runtime nodes. Max 10. | `number` | `1` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_vnet_integration"></a> [vnet\_integration](#input\_vnet\_integration) | "A list of maps containing the vnet ID and the subnet name where nodes will be deployed to. Format:<br>  [{<br>    vnet\_id = "the vnet id"<br>    subnet\_name = "the subnet name"<br>  }]" | `list(map(string))` | `[]` | no |
| <a name="input_vsts_configuration"></a> [vsts\_configuration](#input\_vsts\_configuration) | "Configuration to link ADF to git repo. Format:<br>  {<br>    account\_name    = ""<br>    branch\_name     = ""<br>    project\_name    = ""<br>    repository\_name = ""<br>    root\_folder     = ""<br>    tenant\_id       = ""<br>  }<br>" | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_factory_id"></a> [data\_factory\_id](#output\_data\_factory\_id) | The ID of the data factory instance |
| <a name="output_data_factory_name"></a> [data\_factory\_name](#output\_data\_factory\_name) | The name of the data factory instance |
| <a name="output_datafactory_msi_object_id"></a> [datafactory\_msi\_object\_id](#output\_datafactory\_msi\_object\_id) | Data factory Managed Service Identity principal id |
| <a name="output_integration_runtime_name"></a> [integration\_runtime\_name](#output\_integration\_runtime\_name) | The name of the IR |
| <a name="output_linked_blob_storage_id"></a> [linked\_blob\_storage\_id](#output\_linked\_blob\_storage\_id) | Map of linked blob IDs |
| <a name="output_linked_file_storage_id"></a> [linked\_file\_storage\_id](#output\_linked\_file\_storage\_id) | Map of linked file IDs |
| <a name="output_linked_key_vault_id"></a> [linked\_key\_vault\_id](#output\_linked\_key\_vault\_id) | Map of linked kv IDs |
| <a name="output_linked_sql_server_id"></a> [linked\_sql\_server\_id](#output\_linked\_sql\_server\_id) | Map of linked sql IDs |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
