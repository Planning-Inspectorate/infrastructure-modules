# azure -keyvault

CI for KV

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 1.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_keyvault"></a> [keyvault](#module\_keyvault) | ../../azure-keyvault | n/a |
| <a name="module_keyvault_ca"></a> [keyvault\_ca](#module\_keyvault\_ca) | ../../azure-keyvault | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | List of map of list of string defining access policies for the Key Vault. <br>See [terraform docs](https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#certificate_permissions) for more info.<br>Each map item in the list can define a combination of *user\_principal\_names*, *group\_names* or *object\_ids* with a combination of **secret\_permissions**, **key\_permissions**, **certificate\_permissions** or **storage\_permissions**. <br>All fields are not required to be defined in each map. Eg<br>\<pre>[<br>  {<br>    user_principal_names = ["user1@domain","user2@domain"]<br>    certificate_permissions = ["create","delete","get","import"]<br>  },<br>  {<br>    group_names = ["group","another_group"]<br>    secret_permissions = ["get","list","set"]<br>    key_permissions = ["get","list"]<br>  },<br>  {<br>    object_ids = ["xxxxxxx-xxxxx-xxxx-xxxxxx","yyyyyy-yyyyy-yyyyy-yyyyyy"]<br>    group_names = ["some_group"]<br>    storage_permissions = ["backup","restore"]<br>  }<br>]<br>\</pre> | `list(map(any))` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_ip_rules"></a> [ip\_rules](#input\_ip\_rules) | IPs or IP ranges that are allowed to connect to key vault | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Map of secrets to be added to the vault.  N.B.   Remember values will be stored in tfstate. Only use this to seed initial values, change them after creation | `map(string)` | `{}` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs that are allowed to connect to key vault | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
