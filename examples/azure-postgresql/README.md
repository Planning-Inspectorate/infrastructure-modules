# azure-postgresql

Creates an Azure Database for PostgreSQL - Single Server

## PostgreSQL server module defaults:

* Performance configuration : General Purpose, 2 vCore(s), 5 GB.
* PostgreSQL version        : 11
* SSL enforce status        : ENABLED
* Minimum TLS               : 1.2
* Backup retention          : 7 days
* Storage Auto-growth       : Yes

## Default Local Administrator and the Password

This module creates a local administrator on the PostgreSQL server. If you want to specify an admin username, then use the argument admin\_username with a valid user string.
By default, this module generates a strong password for PostgreSQL admin user.

## Adding Active Directory Administrator to PostgreSQL Database

This module will add a provided Azure Active Directory user/ group to PostgreSQL Database as an administrator so that the user/ group can login to this database with Azure AD authentication.
To add the Active Directory Administrator, use the argument `aad_admin_user` or `aad_admin_group` with a valid Azure AD user/ group login name. Only one can be used so if both are supplied, the `aad_admin_group` is used.

## PostgreSQL database(s):

This module creates a default-database on the PostgreSQL server.
If you want to use a custom database name, specify the list of `postgresql_database`.

Database defaults:

* charset                   : UTF8
* collation                 : English\_United States.1252

## Public Network Access

By default, the module builds the PostgreSQL server with `public_network_access_enabled` set to `false`. As a result, a Private Endpoint will be required in order to connect.

## Firewall rules for a PostgreSQL Server

By default, external access to the PostgreSQL Server will not be possible unless `public_network_access_enabled` is set to `true`. If set, firewall rule(s) should be created.
To add firewall rules, specify a list of `fwrules` with valid `name`, `start_ip_address` and `end_ip_address`.
By default, the module with configure some firewall rules to enable access from Azure services and the shared build agents. The `fwrule_include_sharedBuildAgents` bool is available to allow for scenarios where the default set of shared cicd subnets is not wanted.

## PostgreSQL Configuration

Add a `name` and 'value' to the locals 'postgresql\_configuration' map to set a PostgreSQL configuration value on a PostgreSQL Server. See the PostgreSQL documentation for valid values.

## How To Use

### Example 1

```terraform
module "postgresql" {
  source              = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-postgresql"
  environment         = var.environment
  application         = var.application
  location            = "northeurope"
```

### Example 2

```terraform
module "postgresql" {
  source                        = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-postgresql"
  environment                   = var.environment
  application                   = var.application
  location                      = "northeurope"
  postgresql_database           = "postgresql_database"
  aad_admin_user                = "firstname.surname@domain.com"
  public_network_access_enabled = true
  fwrules                       = var.fwrules
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
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_postgresql_active_directory_administrator.postgresql_aad](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_active_directory_administrator) | resource |
| [azurerm_postgresql_configuration.postgresql_configuration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_configuration) | resource |
| [azurerm_postgresql_database.postgresql_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_database) | resource |
| [azurerm_postgresql_firewall_rule.fwrule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_firewall_rule) | resource |
| [azurerm_postgresql_server.postgresql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_integer.ri](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [random_password.postgresql_server_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azuread_group.aad_admin_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_user.aad_admin_user](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_admin_group"></a> [aad\_admin\_group](#input\_aad\_admin\_group) | An Azure AD admin group | `string` | `""` | no |
| <a name="input_aad_admin_user"></a> [aad\_admin\_user](#input\_aad\_admin\_user) | An Azure AD admin user | `string` | `""` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_fwrule_include_sharedBuildAgents"></a> [fwrule\_include\_sharedBuildAgents](#input\_fwrule\_include\_sharedBuildAgents) | A boolean switch to allow for scenarios where the default set of shared cicd subnets (containing for example Bamboo/ADO agents) should not be added to the PostgreSQL server firewall rules. | `bool` | `true` | no |
| <a name="input_fwrules"></a> [fwrules](#input\_fwrules) | "List of maps detailing firewall rules with the following structure:<br>[<br>  {<br>    name             = "examplefwrule"<br>    start\_ip\_address = "0.0.0.0"<br>    end\_ip\_address   = "0.0.0.0"<br>  }<br>]" | `list(map(string))` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_postgresql_database"></a> [postgresql\_database](#input\_postgresql\_database) | "List of PostgreSQL databases, each map must contain a name field. Optional parameters that can be overriden (defaults can be found under locals.tf):<br>{<br>  charset<br>  collation<br>}" | `list(map(string))` | <pre>[<br>  {<br>    "name": "default-database"<br>  }<br>]</pre> | no |
| <a name="input_postgresql_server_admin_login_name"></a> [postgresql\_server\_admin\_login\_name](#input\_postgresql\_server\_admin\_login\_name) | The login name for the PostgreSQL server administrator (<env><app>\_psqladmin) | `string` | `""` | no |
| <a name="input_postgresql_server_admin_password"></a> [postgresql\_server\_admin\_password](#input\_postgresql\_server\_admin\_password) | The password of the login for the PostgreSQL server administrator. Choose a password that has a minimum of 8 characters and a maximum of 128 characters. The password must contain characters from three of the following categories: English uppercase letters, English lowercase letters, Numbers, Non-alphanumeric characters | `string` | `""` | no |
| <a name="input_postgresql_server_auto_grow"></a> [postgresql\_server\_auto\_grow](#input\_postgresql\_server\_auto\_grow) | Enable/Disable auto-growing of the storage. Storage auto-grow prevents your server from running out of storage and becoming read-only. If storage auto grow is enabled, the storage automatically grows without impacting the workload. The default value if not explicitly specified is true | `bool` | `true` | no |
| <a name="input_postgresql_server_backup_retention"></a> [postgresql\_server\_backup\_retention](#input\_postgresql\_server\_backup\_retention) | Backup retention days for the server, supported values are between 7 and 35 days | `number` | `7` | no |
| <a name="input_postgresql_server_geo_backup"></a> [postgresql\_server\_geo\_backup](#input\_postgresql\_server\_geo\_backup) | Turn Geo-redundant server backups on/off. This allows you to choose between locally redundant or geo-redundant backup storage in the General Purpose and Memory Optimized tiers. When the backups are stored in geo-redundant backup storage, they are not only stored within the region in which your server is hosted, but are also replicated to a paired data center. This provides better protection and ability to restore your server in a different region in the event of a disaster. This is not support for the Basic tier. | `bool` | `false` | no |
| <a name="input_postgresql_server_min_ssl_version"></a> [postgresql\_server\_min\_ssl\_version](#input\_postgresql\_server\_min\_ssl\_version) | The minimum TLS version to support on the sever. Do not use TLS1\_0 or TLS1\_1 | `string` | `"TLS1_2"` | no |
| <a name="input_postgresql_server_name"></a> [postgresql\_server\_name](#input\_postgresql\_server\_name) | PostgreSQL server Name | `string` | `""` | no |
| <a name="input_postgresql_server_sku"></a> [postgresql\_server\_sku](#input\_postgresql\_server\_sku) | Specifies the SKU Name for this PostgreSQL Server. The name of the SKU, follows the tier + family + cores pattern | `string` | `"GP_Gen5_2"` | no |
| <a name="input_postgresql_server_storage"></a> [postgresql\_server\_storage](#input\_postgresql\_server\_storage) | Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 16777216 MB(16TB) for General Purpose/Memory Optimized SKUs. | `number` | `5120` | no |
| <a name="input_postgresql_server_version"></a> [postgresql\_server\_version](#input\_postgresql\_server\_version) | Specifies the version of PostgreSQL to use. Valid values are 9.5, 9.6, 10, 10.0, and 11 | `string` | `"11"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether or not public network access is allowed for this server. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_postgresql_server_fqdn"></a> [postgresql\_server\_fqdn](#output\_postgresql\_server\_fqdn) | FQDN of the PostgreSQL Server |
| <a name="output_postgresql_server_name"></a> [postgresql\_server\_name](#output\_postgresql\_server\_name) | Name of the PostgreSQL Server |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
