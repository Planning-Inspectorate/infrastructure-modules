# sql-with-failover

Example provisioning two PaaS SQL instances configured as a failover group

## How To Update this README.md

terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
Follow the setup instructions here: https://github.com/segmentio/terraform-docs
Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Diagrams

![image info](./diagrams/design.png)

Unfortunately a number of tools that can parse Terraform code/statefiles and generate architetcure diagrams are limited and most are in their infancy. The built in `terraform graph` is only really useful for looking at dependencies and is too verbose to be considered a diagram on an environment.

We can however turn this on its head and look at using deployed resources to produce a diagram as a stop gap. AzViz is a tool which takes one or more resource groups as input and it will parse their contents and produce a more architecture-like diagram. It will also work out the relation between different resources. Check out all its features [here](https://github.com/PrateekKumarSingh/AzViz). To use it to store a diagram post deployment:

```pwsh
Connect-AzAccount
Set-AzContext -Subscription 'xxxx-xxxx'
Export-AzViz -ResourceGroup my-resource-group-1, my-rg-2 -Theme light -OutputFormat png -OutputFilePath 'diagrams/design.png' -CategoryDepth 1 -LabelVerbosity 2
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sql_primary"></a> [sql\_primary](#module\_sql\_primary) | ../../azure-sql | n/a |
| <a name="module_sql_secondary"></a> [sql\_secondary](#module\_sql\_secondary) | ../../azure-sql | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.rg_primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_secondary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_sql_failover_group.sql_failover_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_failover_group) | resource |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.ad_sql_service_account_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_sql_service_account"></a> [ad\_sql\_service\_account](#input\_ad\_sql\_service\_account) | The usename of the Service AD Account pre-created by AD team, as an example svc\_(environment\_code)\_(application)@hiscox.com | `any` | n/a | yes |
| <a name="input_allow_subnet_ids"></a> [allow\_subnet\_ids](#input\_allow\_subnet\_ids) | A map of subnet IDs allow access to the DBs. e.g: { bamboo='...', platform='...' } | `map(string)` | `{}` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_elastic_pool_capacity"></a> [elastic\_pool\_capacity](#input\_elastic\_pool\_capacity) | The scale up/out capacity of the elastic pool, representing server's compute units (vCore-based or DTU-based) N.B. Overrides the capacity set in elastic pool sku | `number` | `4` | no |
| <a name="input_elastic_pool_max_size_gb"></a> [elastic\_pool\_max\_size\_gb](#input\_elastic\_pool\_max\_size\_gb) | The max data size of the elastic pool in gigabytes | `number` | `256` | no |
| <a name="input_elastic_pool_sku"></a> [elastic\_pool\_sku](#input\_elastic\_pool\_sku) | SKU for the pool {name, tier, family, capacity} | `map(string)` | <pre>{<br>  "capacity": 4,<br>  "family": "Gen5",<br>  "name": "BC_Gen5",<br>  "tier": "BusinessCritical"<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of the key vault, used to retrieve the password of the AD SQL account | `string` | n/a | yes |
| <a name="input_key_vault_rg"></a> [key\_vault\_rg](#input\_key\_vault\_rg) | Resource group that contains key vault | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_pool_dbs"></a> [pool\_dbs](#input\_pool\_dbs) | Map of maps containing config for elastic pool databases e.g: { pooldb1={ max\_size = 32, edition='Premium', performance\_level='P1'}, pooldb2={...} ] | `map(map(string))` | `{}` | no |
| <a name="input_sql_failovergroup_grace_minutes"></a> [sql\_failovergroup\_grace\_minutes](#input\_sql\_failovergroup\_grace\_minutes) | Applies only if sql\_failovergroup\_mode is set to automatic. The grace period in minutes before failover with data loss is attempted, must be equal to or greater than 60 minutes | `string` | `"60"` | no |
| <a name="input_sql_failovergroup_mode"></a> [sql\_failovergroup\_mode](#input\_sql\_failovergroup\_mode) | Failover group mode. Possible values are Manual and Automatic | `string` | `"Automatic"` | no |
| <a name="input_sql_server_ads_email_notifications"></a> [sql\_server\_ads\_email\_notifications](#input\_sql\_server\_ads\_email\_notifications) | Space seperated string of email addresses to receieve alerts | `list(string)` | n/a | yes |
| <a name="input_standalone_dbs"></a> [standalone\_dbs](#input\_standalone\_dbs) | Map of maps containing config for standalone databases e.g: { db1={ max\_size = 32, edition='Premium', performance\_level='P1'}, db2={...} ] | `map(map(string))` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_name_primary"></a> [resource\_group\_name\_primary](#output\_resource\_group\_name\_primary) | Name of the resource group where resources have been deployed to |
| <a name="output_resource_group_name_secondary"></a> [resource\_group\_name\_secondary](#output\_resource\_group\_name\_secondary) | Name of the resource group where resources have been deployed to |
