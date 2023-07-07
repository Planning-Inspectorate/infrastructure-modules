# azure -keyvault

Creates a keyvault and assigns appropriate roles to manage secrets and certs

Purge protection & soft delete retention - Purge protection has now been enabled by default on production keyvaults (even if 'purge\_protection\_enabled' is set to false) and the default soft delete retention has
been set to 90 days (previously 7). Purge protection can still be enabled on non-production vaults if explicitly set. N.B. If you expect to have to build and destroy a keyvault with purge protection enabled, you will
not be able to build another vault with the same name for 90 days. Consider appending the keyvault name with random characters if there is a need to destroy and rebuild.
A lifecycle block has been added for 'soft\_delete\_retention\_days' and 'purge\_protection\_enabled' parameters to prevent breaking changes to existing keyvaults. Please update these settings manually to ensure older vaults
conform with standards.

## How To Use

Note: when using audit logging with a Log Analytics Workspace or Storage account you will need to add a `depends_on` block inside your `module "keyvault"` declaration otherwise the data types for finding the IDs will execute too early. For example if you're building a storage account alonogside the KV for audit logging you can add something like this to your KV module block:

```terraform
depends_on [
  module.storage
]
```

## Basic

```terraform
module "keyvault" {
  source          = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-keyvault"
  environment = "dev"
  application = "app"
  location    = "northeurope"
  access_policies = [
      {
      user_principal_names = ["fred.bloggs@hiscox.com","joe.public@hiscox.com"]
      secret_permissions   = ["get","set","list"]
      },
      {
      group_names             = ["ClusterAdmins"]
      certificate_permissions = ["get","list","import"]
      },
  ]
  secrets = {
    the-secret = "A secret stored in the vault",
    another-secret = "Another secret stored in the vault"
  }
}
```

This will create a keyvault called `dvmyappkvne` in resource group `dev-myapp-kv-northeurope`.
It will assign secret access rights to two users and certificate access to a group.
See [the official documentation](https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#certificate_permissions) for more info
on the specific permissions that can be applied.
It will add two secrets to the vault.  N.B.  The values will be retained on terraform.state, so ensure state is encrypted before storing.

## Certificate Authority integrated KeyVault

```terraform
module "keyvault" {
  source                             = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-keyvault"
  resource_group_name                = azurerm_resource_group.resource_group.name
  environment                        = var.environment
  application                        = var.application
  location                           = var.location
  ca_integration                     = true
  issuer_name                        = local.issuer_name
  provider_name                      = "DigiCert"
  ca_org_id                          = var.digicert_org_id
  ca_user                            = var.digicert_api_user
  ca_secret                          = var.digicert_api_password
  admin_email                        = var.admin_email
  admin_firstname                    = var.admin_firstname
  admin_lastname                     = var.admin_lastname
  admin_phone                        = var.admin_phone
}

This will create a KeyVault which is integrated with DigiCert for the issuing of publicly signed TLS/SSL certificates.
The "azurerm_key_vault_certificate" Terraform resource can be used to define the certificates

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 1.4, < 2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2, < 3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3, < 4 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2, < 3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 1.4, < 2 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_certificate_issuer.certificate-issuer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate_issuer) | resource |
| [azurerm_key_vault_secret.secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_monitor_diagnostic_setting.key_vault_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azuread_group.groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_user.users](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | List of map of list of string defining access policies for the Key Vault. <br>See [terraform docs](https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#certificate_permissions) for more info.<br>Each map item in the list can define a combination of *user\_principal\_names*, *group\_names* or *object\_ids* with a combination of **secret\_permissions**, **key\_permissions**, **certificate\_permissions** or **storage\_permissions**. <br>All fields are not required to be defined in each map. Eg<br>\<pre>[<br>  {<br>    user_principal_names = ["user1@domain","user2@domain"]<br>    certificate_permissions = ["create","delete","get","import"]<br>  },<br>  {<br>    group_names = ["group","another_group"]<br>    secret_permissions = ["get","list","set"]<br>    key_permissions = ["get","list"]<br>  },<br>  {<br>    object_ids = ["xxxxxxx-xxxxx-xxxx-xxxxxx","yyyyyy-yyyyy-yyyyy-yyyyyy"]<br>    group_names = ["some_group"]<br>    storage_permissions = ["backup","restore"]<br>  }<br>]<br>\</pre> | `list(map(any))` | `[]` | no |
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | Details for certificate issuer admin | `string` | `"platformservicesgroup@hiscox.com"` | no |
| <a name="input_admin_firstname"></a> [admin\_firstname](#input\_admin\_firstname) | Details for certificate issuer admin | `string` | `"CA"` | no |
| <a name="input_admin_lastname"></a> [admin\_lastname](#input\_admin\_lastname) | Details for certificate issuer admin | `string` | `"Admin"` | no |
| <a name="input_admin_phone"></a> [admin\_phone](#input\_admin\_phone) | Details for certificate issuer admin | `string` | `"1234567890"` | no |
| <a name="input_all_metrics_retention_days"></a> [all\_metrics\_retention\_days](#input\_all\_metrics\_retention\_days) | The number of days that the AllMetrics metrics should be retained for | `number` | `30` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_audit_event_retention_days"></a> [audit\_event\_retention\_days](#input\_audit\_event\_retention\_days) | The number of days that the AuditEvent logs should be retained for | `number` | `30` | no |
| <a name="input_ca_integration"></a> [ca\_integration](#input\_ca\_integration) | Integrate with certificate issuer? | `bool` | `false` | no |
| <a name="input_ca_org_id"></a> [ca\_org\_id](#input\_ca\_org\_id) | Certificate issuer Org ID | `string` | `"CA Org Id"` | no |
| <a name="input_ca_secret"></a> [ca\_secret](#input\_ca\_secret) | Certificate issuer account password | `string` | `"CA password"` | no |
| <a name="input_ca_user"></a> [ca\_user](#input\_ca\_user) | Certificate issuer account username | `string` | `"CA user"` | no |
| <a name="input_enable_all_metrics_retention_policy"></a> [enable\_all\_metrics\_retention\_policy](#input\_enable\_all\_metrics\_retention\_policy) | Flag to be used if it is desired to set a custom retention policy for AllMetrics metrics. Possible values are "true" and "false" | `bool` | `false` | no |
| <a name="input_enable_audit_event_retention_policy"></a> [enable\_audit\_event\_retention\_policy](#input\_enable\_audit\_event\_retention\_policy) | Flag to be used if it is desired to set a custom retention policy for AuditEvent logs. Possible values are "true" and "false" | `bool` | `false` | no |
| <a name="input_enable_diagnostics"></a> [enable\_diagnostics](#input\_enable\_diagnostics) | Flag to be used if diagnostics monitoring is desired in compliance with Azure CIS 1.1.0. Possible values are "true" and "false" | `string` | `"false"` | no |
| <a name="input_enable_law_diagnostics"></a> [enable\_law\_diagnostics](#input\_enable\_law\_diagnostics) | Flag use to deterministically set Log Analytics Workspace for use by diagnostics setting. Must be used in conjunction with `enable_diagnostics` field. | `bool` | `true` | no |
| <a name="input_enable_storage_account_diagnostics"></a> [enable\_storage\_account\_diagnostics](#input\_enable\_storage\_account\_diagnostics) | Flag used to deterministically set storage account for use by diagnostics setting. Must be used in conjunction with `enable_diagnostics` field. | `bool` | `true` | no |
| <a name="input_enable_user_supplied_environment"></a> [enable\_user\_supplied\_environment](#input\_enable\_user\_supplied\_environment) | Flag to be used to enable user supplied name insted of auto generated name. Possible values are "true" and "false" | `string` | `"false"` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault | `bool` | `true` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys | `bool` | `true` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_ip_rules"></a> [ip\_rules](#input\_ip\_rules) | IPs or IP ranges that are allowed to connect to key vault | `list(string)` | `[]` | no |
| <a name="input_issuer_name"></a> [issuer\_name](#input\_issuer\_name) | Certificate issuer name | `string` | `"CA authority"` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_log_analytics_name"></a> [log\_analytics\_name](#input\_log\_analytics\_name) | Name of log anaylitics space to use for diagnostics logging. Required if enable\_diagnostics is enabled | `string` | `""` | no |
| <a name="input_log_analytics_rg"></a> [log\_analytics\_rg](#input\_log\_analytics\_rg) | Resource group of log anaylitics space to use for diagnostics logging. Required if enable\_diagnostics is enabled | `string` | `""` | no |
| <a name="input_provider_name"></a> [provider\_name](#input\_provider\_name) | Certificate provider name | `string` | `"CA authority"` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | Is Purge Protection enabled for this Key Vault? | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Map of secrets to be added to the vault.  N.B.   Remember values will be stored in tfstate. Only use this to seed initial values, change them after creation | `map(string)` | `{}` | no |
| <a name="input_soft_delete_enabled"></a> [soft\_delete\_enabled](#input\_soft\_delete\_enabled) | Should Soft Delete be enabled for this Key Vault? | `bool` | `false` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | The number of days that items should be retained for once soft-deleted | `number` | `90` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Name of storage account space to use for diagnostics logging. Required if enable\_diagnostics is enabled | `string` | `""` | no |
| <a name="input_storage_account_rg"></a> [storage\_account\_rg](#input\_storage\_account\_rg) | Resource group of storage account space to use for diagnostics logging. Required if enable\_diagnostics is enabled | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs that are allowed to connect to key vault | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_vault_sku"></a> [vault\_sku](#input\_vault\_sku) | Quality of the vault. Options are standard or premium | `string` | `"standard"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_keyvault_id"></a> [keyvault\_id](#output\_keyvault\_id) | Vault ID |
| <a name="output_keyvault_name"></a> [keyvault\_name](#output\_keyvault\_name) | Vault name |
| <a name="output_keyvault_uri"></a> [keyvault\_uri](#output\_keyvault\_uri) | Vaults uri |
| <a name="output_location"></a> [location](#output\_location) | Vault location |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
