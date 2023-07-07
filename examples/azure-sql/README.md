# azure-sql

Creates an azure sql server with optional standalone or elastic pool databases
It supports the setting of sql-server-level firewall rules and AAD administrator

The AAD admin can be a user or a group, but defaults to zSQLAdmin (Data Tribe admin group)
Note that this will mean for previously unset Azure SQL server AAD admins, this DBA admin group will now be set (as a in-place, non-breaking change)
This is recommended to give the Hiscox DBAs access to all SQL servers

Supports the deployment of serverless databases (see 'sql-serverless-with-users' under the `examples` directory), when a valid SKU is passed. Serverless databases
cannot be deployed into an elastic pool. For serverless dbs there are two optional parameters for the 'standalone\_dbs' variable, 'auto\_pause\_delay\_in\_minutes'  
and 'min\_capacity', with both defaulting to null for provisioned databases. Be aware that if 'auto\_pause\_delay\_in\_minutes' is set to anything other that -1
(disabled) then long term retention policies will not be applied.

Soft delete will be auto enabled on the storage accounts in production environments. The retention period set for both the container and blobs is 90 days.

Contained database users (SQL users, AD users / Groups, MI or SP) can be created via the module with db roles assigned (See 'sql-serverless-with-users'
under the `examples` directory). If permissions are to be managed via groups (as is recommended) then Azure AD groups need to be created for Azure objects
such as Managed Identities or Service Principles

## Where appropriate it is recommended that the below AD objects be created in advanced for each environment, before the respective contained users are applied in Terraform:

* Active Directory on prem: create an OU named after the environment under the path `OU=${application},OU=${project/program},OU=${subscription},OU=Azure,DC=HISCOX,DC=COM` with the below security groups:

  ${environment}\_${application}\_db\_owner

  ${environment}\_${application}\_db\_writer

  ${environment}\_${application}\_db\_reader

* Azure Active Directory: for each environment create the following security groups:

  ${environment}\_${application}\_db\_owner\_mi

  ${environment}\_${application}\_db\_writer\_mi

  ${environment}\_${application}\_db\_reader\_mi

* Build agent for infrastructure requires: Azure CLI, Terraform, SQLCMD v13.1+
* The Service Principal used to execute this terraform requires permissions to `Read and write all applications`, `Read and write directory data` and `Sign in and read user profile` within the Windows Azure Active Directory API
* Service Endpoints: the local vnet requires two service endpoints, Microsoft.Sql and Microsoft.Storage. Your bamboo agent vnet requires the Microsoft.Sql service endpoint to permit deployments

## How To Use

NB: to create a failover cluster take a look at `sql-with-failover` under the `examples` directory

### Elastic Pool

```terraform
module "sql_primary" {
  source                   = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-sql"
  environment                        = var.environment
  application                        = var.application
  resource_group_name                = azurerm_resource_group.rg_primary.name
  location                           = "northeurope"
  allow_subnet_ids                   = var.allow_subnet_ids
  elastic_pool_capacity              = var.elastic_pool_capacity
  elastic_pool_sku                   = var.elastic_pool_sku
  pool_dbs                           = var.pool_dbs
  sql_server_ads_email_notifications = var.sql_server_ads_email_notifications
  ad_sql_service_account             = var.ad_sql_service_account
  ad_sql_service_account_password    = var.ad_sql_service_account_password
}
```

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Items for next major version

1. The code around firewall rules need to be tidied up / combined. Due to evolving changes, firewall restrictions have been separately introduced for the storage account and for the azure sql server. The following items to change should be considered:
  - Combine the specification of firewall rules into a single variable, now clearly applicable to both storage account and sql server
  - Leave in the logic (but maybe tidy as a result of other points here) around only adding FW rules to SQL server for the same region (storage accounts can have FW rules from ALL regions)
  - Add possibility to pass in details of an existing storage account rather than this module always creating one?
  - Remove from the storage account TF code the example around support for the use case for cloud witnesses - this is irrelevant to this azure-sql module

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 1.4, < 2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2, < 3 |
| <a name="requirement_mssql"></a> [mssql](#requirement\_mssql) | 0.2.4 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3, < 4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 1.4, < 2 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |
| <a name="provider_mssql"></a> [mssql](#provider\_mssql) | 0.2.4 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3, < 4 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_mssql_database.database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_database.pool_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_elasticpool.pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_elasticpool) | resource |
| [azurerm_mssql_server.sql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_server_extended_auditing_policy.audit_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) | resource |
| [azurerm_mssql_server_security_alert_policy.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_security_alert_policy) | resource |
| [azurerm_mssql_server_vulnerability_assessment.va](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_vulnerability_assessment) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.blob_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_sql_firewall_rule.sql_firewall_azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_firewall_rule) | resource |
| [azurerm_sql_firewall_rule.sql_firewall_mspeering_tc1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_firewall_rule) | resource |
| [azurerm_sql_firewall_rule.sql_firewall_mspeering_tc2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_firewall_rule) | resource |
| [azurerm_sql_virtual_network_rule.sqlvnetrule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_virtual_network_rule) | resource |
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_network_rules.storage-network-rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules) | resource |
| [azurerm_storage_container.container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [mssql_user.database_users](https://registry.terraform.io/providers/betr-io/mssql/0.2.4/docs/resources/user) | resource |
| [random_password.sql_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.storage_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azuread_group.sql_admin_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_user.sql_admin_user](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_sql_service_account"></a> [ad\_sql\_service\_account](#input\_ad\_sql\_service\_account) | The username or the group name AAD SQL server admin. If its a user, this is traditionally the service AD Account pre-created by AD team, as an example svc\_(environment\_code)\_(application)@hiscox.com | `string` | `""` | no |
| <a name="input_ad_sql_service_account_password"></a> [ad\_sql\_service\_account\_password](#input\_ad\_sql\_service\_account\_password) | The password of the Service AD Account pre-created by AD team as an example svc\_(environment\_code)\_(application)@hiscox.com | `string` | `""` | no |
| <a name="input_allow_subnet_ids"></a> [allow\_subnet\_ids](#input\_allow\_subnet\_ids) | A map of subnet IDs allow access to the DBs. e.g: { bamboo='...', platform='...' } | `map(string)` | `{}` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_audit_retention_days"></a> [audit\_retention\_days](#input\_audit\_retention\_days) | The number of days to retain logs for in the storage account | `number` | `90` | no |
| <a name="input_container_access_type"></a> [container\_access\_type](#input\_container\_access\_type) | The Access Level configured for this Container. Possible values are blob, container or private | `string` | `"private"` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | List of names for created containers | `list(string)` | <pre>[<br>  "vulnerability-assessment"<br>]</pre> | no |
| <a name="input_database_users"></a> [database\_users](#input\_database\_users) | "List of map of strings detailng contained users to be created in Azure SQL DBs. The map structure is dependant on the user type (examples below).<br>NB: The 'database\_user\_role' parameter requires be a comma seperated list of db roles<br>[<br>  # SQL user example #<br>  {<br>    database\_name          = "dbname"<br>    database\_user          = "username"<br>    database\_user\_password = "xxxxxxxx"<br>    database\_user\_role     = "db\_datareader, db\_datawriter"<br>  },<br>  # AD user example #<br>  {<br>    database\_name          = "dbname"<br>    database\_user          = "user@hiscox.com"<br>    object\_id              = "xxxxx-xxxx-xxxx-xxxx-xxxxx"<br>    database\_user\_role     = "db\_accessadmin, db\_datareader"<br>  },<br>  # AD group / MI / SP example #<br>  {<br>    database\_name          = "dbname"<br>    database\_user          = "adobjectname"<br>    object\_id              = "xxxxx-xxxx-xxxx-xxxx-xxxxx"<br>    database\_user\_role     = "db\_owner"<br>  },<br>]" | `list(map(any))` | `[]` | no |
| <a name="input_db_bck_retention_days"></a> [db\_bck\_retention\_days](#input\_db\_bck\_retention\_days) | Number of days to keep as a backup for the database. It will configure the short Azure backup retention policy. Azure default is 7 and can go up to 35 | `number` | `35` | no |
| <a name="input_elastic_pool_capacity"></a> [elastic\_pool\_capacity](#input\_elastic\_pool\_capacity) | The scale up/out capacity of the elastic pool, representing server's compute units (vCore-based or DTU-based) N.B. Overrides the capacity set in elastic pool sku | `number` | `4` | no |
| <a name="input_elastic_pool_max_size_gb"></a> [elastic\_pool\_max\_size\_gb](#input\_elastic\_pool\_max\_size\_gb) | The max data size of the elastic pool in gigabytes | `number` | `256` | no |
| <a name="input_elastic_pool_sku"></a> [elastic\_pool\_sku](#input\_elastic\_pool\_sku) | "SKU for the pool {name, tier, family, capacity}, e.g {<br>  name     = "BC\_Gen5"<br>  tier     = "BusinessCritical"<br>  family   = "Gen5"<br>  capacity = 4<br>}" | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_environment_code"></a> [environment\_code](#input\_environment\_code) | Shorthand environment name based on server-identification | `string` | `"ci"` | no |
| <a name="input_is_db_bck_longterm_retention_required"></a> [is\_db\_bck\_longterm\_retention\_required](#input\_is\_db\_bck\_longterm\_retention\_required) | Flag used to identify if long term retention policy is required for sql server databasess. 1 for true and 0 for false | `number` | `1` | no |
| <a name="input_is_secondary"></a> [is\_secondary](#input\_is\_secondary) | Boolean defining whether this SQL server will be a secondary - any databases created will have their `creat_mode` set to `Secondary` | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_ltr_weekly_retention"></a> [ltr\_weekly\_retention](#input\_ltr\_weekly\_retention) | Retention of the weekly backup, typically use P1M for production workloads | `string` | `"P7D"` | no |
| <a name="input_ltr_yearly_retention"></a> [ltr\_yearly\_retention](#input\_ltr\_yearly\_retention) | Retention of the yearly backup, typically use P10Y for production workloads | `string` | `"P7D"` | no |
| <a name="input_network_default_action"></a> [network\_default\_action](#input\_network\_default\_action) | If a source IPs fails to match a rule should it be allowed for denied | `string` | `"Deny"` | no |
| <a name="input_network_rule_ips"></a> [network\_rule\_ips](#input\_network\_rule\_ips) | List of public IPs that are allowed to access the storage account. Private IPs in RFC1918 are not allowed here | `list(string)` | `[]` | no |
| <a name="input_network_rule_virtual_network_subnet_ids"></a> [network\_rule\_virtual\_network\_subnet\_ids](#input\_network\_rule\_virtual\_network\_subnet\_ids) | List of subnet IDs which are allowed to access the storage account | `list(string)` | `[]` | no |
| <a name="input_network_rule_virtual_network_subnet_ids_include_cicd_agents"></a> [network\_rule\_virtual\_network\_subnet\_ids\_include\_cicd\_agents](#input\_network\_rule\_virtual\_network\_subnet\_ids\_include\_cicd\_agents) | A boolean switch to allow for scenarios where the default set of cicd subnets (containing for example Bamboo/ADO agents) should not be added to the storage accounts network rules. An example would be a storage accounts used as a cloud witness for a windows failover cluster that exists outside of the paired regions of the cluster nodes | `bool` | `true` | no |
| <a name="input_pool_dbs"></a> [pool\_dbs](#input\_pool\_dbs) | Map of maps containing config for elastic pool databases e.g: { pooldb1={ max\_size = 32, edition='Premium', performance\_level='P1'}, pooldb2={...} ] | `map(map(string))` | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_security_disabled_alerts"></a> [security\_disabled\_alerts](#input\_security\_disabled\_alerts) | List of disabled security alert types - see https://www.terraform.io/docs/providers/azurerm/r/mssql_server_security_alert_policy.html#disabled_alerts for info. | `list(string)` | `[]` | no |
| <a name="input_security_retention_days"></a> [security\_retention\_days](#input\_security\_retention\_days) | Retention of security audit and threat protection info | `number` | `0` | no |
| <a name="input_short_term_backup_retention"></a> [short\_term\_backup\_retention](#input\_short\_term\_backup\_retention) | Number of days to keep short term backups. Can be between 7 and 35. | `number` | `35` | no |
| <a name="input_source_dbs"></a> [source\_dbs](#input\_source\_dbs) | Map of strings defining source database IDs for when server is being created as a secondary replica eg { "name" = "id" } | `map(string)` | `{}` | no |
| <a name="input_sql_admin_group"></a> [sql\_admin\_group](#input\_sql\_admin\_group) | The name of the SQL server administrator group | `string` | `"zSQLAdmin"` | no |
| <a name="input_sql_server_admin_password"></a> [sql\_server\_admin\_password](#input\_sql\_server\_admin\_password) | The password of the login for the SQL server administrator (<env><app>\_sqladmin) | `string` | `""` | no |
| <a name="input_sql_server_ads_email_notifications"></a> [sql\_server\_ads\_email\_notifications](#input\_sql\_server\_ads\_email\_notifications) | Required emails for SQL Server advance security notifications | `list(string)` | `[]` | no |
| <a name="input_sql_server_version"></a> [sql\_server\_version](#input\_sql\_server\_version) | Version of SQL Server | `string` | `"12.0"` | no |
| <a name="input_standalone_dbs"></a> [standalone\_dbs](#input\_standalone\_dbs) | "Map of maps containing config for standalone databases (min\_capacity and auto\_pause\_delay\_in\_minutes are only relevant for serverless databases and will default to null when not populated) e.g: <br>  {<br>    standalonedb = {<br>      max\_size\_gb                 = 6<br>      sku\_name                    = "GP\_S\_Gen5\_1"<br>      collation                   = "Latin1\_General\_CS\_AI"<br>      min\_capacity                = 1<br>      auto\_pause\_delay\_in\_minutes = 60<br>    }<br>  }" | `map(map(string))` | `{}` | no |
| <a name="input_storage_soft_delete_retention_policy"></a> [storage\_soft\_delete\_retention\_policy](#input\_storage\_soft\_delete\_retention\_policy) | Is soft delete enabled for containers and blobs? | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_ad_account"></a> [admin\_ad\_account](#output\_admin\_ad\_account) | AD admin account (service account) |
| <a name="output_elastic_pool_id"></a> [elastic\_pool\_id](#output\_elastic\_pool\_id) | Id of the elastic pool on North Europe |
| <a name="output_pool_db_data"></a> [pool\_db\_data](#output\_pool\_db\_data) | Map of the pool databases |
| <a name="output_pool_db_ids"></a> [pool\_db\_ids](#output\_pool\_db\_ids) | List of pool database IDs |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
| <a name="output_sql_admin_login"></a> [sql\_admin\_login](#output\_sql\_admin\_login) | Name of the SQL administrator login |
| <a name="output_sql_admin_server_password"></a> [sql\_admin\_server\_password](#output\_sql\_admin\_server\_password) | Local SQL admin user password output so it can be saved on Keyvault |
| <a name="output_sql_server_id"></a> [sql\_server\_id](#output\_sql\_server\_id) | ID os the SQL instance |
| <a name="output_sql_server_name"></a> [sql\_server\_name](#output\_sql\_server\_name) | Name of the SQL instance |
| <a name="output_sql_server_name_fqdn"></a> [sql\_server\_name\_fqdn](#output\_sql\_server\_name\_fqdn) | Name of the SQL instance |
| <a name="output_standalone_db_data"></a> [standalone\_db\_data](#output\_standalone\_db\_data) | Map of the standalone databases |
| <a name="output_standalone_db_ids"></a> [standalone\_db\_ids](#output\_standalone\_db\_ids) | List of standalone database IDs |
| <a name="output_standalone_db_names"></a> [standalone\_db\_names](#output\_standalone\_db\_names) | List of standalone database Names |
| <a name="output_storage_id"></a> [storage\_id](#output\_storage\_id) | ID of the storage account used for sql |
| <a name="output_storage_name"></a> [storage\_name](#output\_storage\_name) | Name of the storage account used for sql |
