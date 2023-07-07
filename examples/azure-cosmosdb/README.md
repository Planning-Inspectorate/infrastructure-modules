# azure-cosmosdb

This directory stands up a CosmosDb instance

## How To Use

### Basic CosmosDb Account

```terraform
module "tempalte" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-cosmosdb"
  environment = "dev"
  application = "app"
  location    = "northeurope"
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
| [azurerm_cosmosdb_account.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_integer.ri](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_auto_failover"></a> [auto\_failover](#input\_auto\_failover) | Should automatic failover be enabled | `bool` | `true` | no |
| <a name="input_capabilities"></a> [capabilities](#input\_capabilities) | The capabilities which should be enabled for this Cosmos DB account. Possible values are EnableAggregationPipeline, EnableCassandra, EnableGremlin, EnableTable, MongoDBv3.4, and mongoEnableDocLevelTTL | `list(string)` | <pre>[<br>  "EnableTable"<br>]</pre> | no |
| <a name="input_consistency_level"></a> [consistency\_level](#input\_consistency\_level) | Consistency can be Session, Eventual, Strong, BoundedStaleness, ConsistentPrefix | `string` | `"Session"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_failover_location"></a> [failover\_location](#input\_failover\_location) | The region resources will fail over to | `string` | `"westeurope"` | no |
| <a name="input_ip_range_filter"></a> [ip\_range\_filter](#input\_ip\_range\_filter) | Comma separated single-string of IPs/ranges that are allowed client IPs to access this account | `string` | `null` | no |
| <a name="input_kind"></a> [kind](#input\_kind) | Kind of cosmosdb to create | `string` | `"GlobalDocumentDB"` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet access should be restricted to | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cosmos_connection_strings"></a> [cosmos\_connection\_strings](#output\_cosmos\_connection\_strings) | List of connection strings |
| <a name="output_cosmos_endpoint"></a> [cosmos\_endpoint](#output\_cosmos\_endpoint) | Endpoint to connect to the CosmosDb account |
| <a name="output_cosmos_id"></a> [cosmos\_id](#output\_cosmos\_id) | Cosmos ID |
| <a name="output_cosmos_primary_master_key"></a> [cosmos\_primary\_master\_key](#output\_cosmos\_primary\_master\_key) | Primary master key |
| <a name="output_cosmos_primary_readonly_master_key"></a> [cosmos\_primary\_readonly\_master\_key](#output\_cosmos\_primary\_readonly\_master\_key) | Primary read-only master key |
| <a name="output_cosmos_read_endpoints"></a> [cosmos\_read\_endpoints](#output\_cosmos\_read\_endpoints) | Read endpoints |
| <a name="output_cosmos_secondary_master_key"></a> [cosmos\_secondary\_master\_key](#output\_cosmos\_secondary\_master\_key) | Secondary master key |
| <a name="output_cosmos_secondary_readonly_master_key"></a> [cosmos\_secondary\_readonly\_master\_key](#output\_cosmos\_secondary\_readonly\_master\_key) | Secondary read-only master key |
| <a name="output_cosmos_write_endpoints"></a> [cosmos\_write\_endpoints](#output\_cosmos\_write\_endpoints) | Write endpoints |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
