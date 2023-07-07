# azure-storage-account

Creates an Azure Storage Account and optionally different modes of storage. By default all private and public access if forbidden as well access from Azure Services. To permit access you need ot supply a list of public IPs and/or a list of subnet IDs.

As Storage Account names must be globally unique we default to generating a random string for the name - as everything should be driven through automation the name is not generally important. If however you need a very specific name for a Storage Account you can override the auto generated name through the variable `storage_name`.

Soft delete will be auto enabled on any storage accounts created in production environments and can be explicitly set for other environments using the 'soft\_delete\_retention\_policy' bool. The retention period set for both the container and blobs is 90 days.

NB: if you create storage with blobs/shares/tables/queues without any specific network rules Terraform will be 403'ed when attempting to apply/destroy future changes as it's unable to read the remote state of the resource(s)

## How To Use

Outputs should be used as inputs in a parent module

### Standalone Storage Account

```terraform
module "storage" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
  environment = "dev"
  application = "app"
  location    = "northeurope"
}
```

### Standalone Storage Account which allows network access

```terraform
module "storage" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
  environment = "dev"
  application = "app"
  location    = "northeurope"
  network_rule_ips = ["127.0.0.1"]
}
```

### Blob storage

```terraform
module "storage" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
  environment = "dev"
  application = "app"
  location    = "northeurope"
  container_name = ["first-container"]
  blobs = [
    {
      name = "exampleblob"
      container_name = "first-container"
      type = "Block"
      size = "512"
    }
  ]
}
```

### Queue Storage

```terraform
module "storage" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
  environment = "dev"
  application = "app"
  location    = "northeurope"
  queue_name = ["firstqueue", "secondqueue"]
}
```

### Share Storage

```terraform
module "storage" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
  environment = "dev"
  application = "app"
  location    = "northeurope"
  shares = [
    {
      name = "exampleshare"
      quota = "101"
    }
  ]

  NOTE - At present share directories only support creation at the root of the share. A directory with a parent of another directory is not supported. Directory structures should be created post Storage Account creation.
  share_directories = {
    dirOne = "exampleshare"
    dirTwo = "exampleshare"
  }
}
```

### Table Storage

```terraform
module "storage" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
  environment = "dev"
  application = "app"
  location    = "northeurope"
  tables      = ["tableOne", "tableTwo"]
}
```

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.37, < 3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3, < 4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.37, < 3 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3, < 4 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_network_rules.storage-network-rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules) | resource |
| [azurerm_storage_blob.blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_data_lake_gen2_filesystem.storage_dlg2fs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem) | resource |
| [azurerm_storage_queue.queue](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_queue) | resource |
| [azurerm_storage_share.share](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |
| [azurerm_storage_share_directory.share_directories](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share_directory) | resource |
| [azurerm_storage_table.table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table) | resource |
| [random_string.storage_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | Performance/Access tier. Accepts Hot, Cool | `string` | `"Hot"` | no |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2 | `string` | `"StorageV2"` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_blobs"></a> [blobs](#input\_blobs) | "List of maps detailing blobs with the following structure (size must be 0 or in multiples of 512):<br>[<br>  {<br>    name           = "exampleblob"<br>    container\_name = "first-container"<br>    type           = "Block"<br>    size           = "512" #optional<br>    source         = "./dist/somezip.zip" #optional<br>  }<br>]" | `list(map(string))` | `[]` | no |
| <a name="input_container_access_type"></a> [container\_access\_type](#input\_container\_access\_type) | The Access Level configured for this Container. Possible values are blob, container or private | `string` | `"private"` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | List of names for created containers | `list(string)` | `[]` | no |
| <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain) | A custom domain that should be used for the storage account | `list(map(string))` | `[]` | no |
| <a name="input_directory_type"></a> [directory\_type](#input\_directory\_type) | Defines whether the Storage Account will be joined to the Hiscox.com AD in order to provide identity based auth / RBAC to File Shares | `string` | `"not-ad-joined"` | no |
| <a name="input_dlg2fs"></a> [dlg2fs](#input\_dlg2fs) | List of data lake gen2 filesystem names (only lowercase alphanumeric characters and hyphens allowed) | `list(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_is_hns_enabled"></a> [is\_hns\_enabled](#input\_is\_hns\_enabled) | Is Hierarchical Namespace enabled? | `bool` | `false` | no |
| <a name="input_large_file_share_enabled"></a> [large\_file\_share\_enabled](#input\_large\_file\_share\_enabled) | Bool to define whether Large File Share is enabled | `bool` | `"false"` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_network_default_action"></a> [network\_default\_action](#input\_network\_default\_action) | If a source IPs fails to match a rule should it be allowed for denied | `string` | `"Deny"` | no |
| <a name="input_network_rule_bypass"></a> [network\_rule\_bypass](#input\_network\_rule\_bypass) | Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None | `list(string)` | <pre>[<br>  "None"<br>]</pre> | no |
| <a name="input_network_rule_ips"></a> [network\_rule\_ips](#input\_network\_rule\_ips) | List of public IPs that are allowed to access the storage account. Private IPs in RFC1918 are not allowed here | `list(string)` | `[]` | no |
| <a name="input_network_rule_virtual_network_subnet_ids"></a> [network\_rule\_virtual\_network\_subnet\_ids](#input\_network\_rule\_virtual\_network\_subnet\_ids) | List of subnet IDs which are allowed to access the storage account | `list(string)` | `[]` | no |
| <a name="input_network_rule_virtual_network_subnet_ids_include_cicd_agents"></a> [network\_rule\_virtual\_network\_subnet\_ids\_include\_cicd\_agents](#input\_network\_rule\_virtual\_network\_subnet\_ids\_include\_cicd\_agents) | A boolean switch to allow for scenarios where the default set of cicd subnets (containing for example Bamboo/ADO agents) should not be added to the storage accounts network rules. An example would be a storage accounts used as a cloud witness for a windows failover cluster that exists outside of the paired regions of the cluster nodes | `bool` | `true` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | List of names for queues | `list(string)` | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_share_directories"></a> [share\_directories](#input\_share\_directories) | "Map of share directory names where the value is the name of the share. For example:<br>dirOne = "exampleshare"<br>dirTwo = "exampleshare"" | `map(string)` | `{}` | no |
| <a name="input_shares"></a> [shares](#input\_shares) | "List of maps detailing shares with the following structure:<br>[<br>  {<br>    name  = "exampleshare"<br>    quota = "101"<br>  }<br>]" | `list(map(string))` | `[]` | no |
| <a name="input_soft_delete_retention_policy"></a> [soft\_delete\_retention\_policy](#input\_soft\_delete\_retention\_policy) | Is soft delete enabled for containers and blobs? | `bool` | `false` | no |
| <a name="input_static_website"></a> [static\_website](#input\_static\_website) | "A static website that should be hosting from this storage account. The amp format must be:<br>static\_website = {<br>  index\_document     = "your\_index.html"<br>  error\_404\_document = "a\_page\_to\_display\_for\_404"<br>}" | `map(string)` | `{}` | no |
| <a name="input_storage_name"></a> [storage\_name](#input\_storage\_name) | Name of the storage account | `string` | `""` | no |
| <a name="input_storage_replication"></a> [storage\_replication](#input\_storage\_replication) | Type of replication. Accepts LRS, GRS, RAGRS and ZRS | `string` | `"LRS"` | no |
| <a name="input_storage_sid"></a> [storage\_sid](#input\_storage\_sid) | SID of a pre-staged hiscox.com AD computer object for the storage account. Required if directory\_type is set to ad-joined. | `string` | `null` | no |
| <a name="input_storage_tier"></a> [storage\_tier](#input\_storage\_tier) | Quality of storage to use. Accepts Standard or Premium | `string` | `"Standard"` | no |
| <a name="input_tables"></a> [tables](#input\_tables) | List of table names | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_blob_id"></a> [blob\_id](#output\_blob\_id) | The IDs of blobs |
| <a name="output_container_id"></a> [container\_id](#output\_container\_id) | The IDs of storage containers |
| <a name="output_location"></a> [location](#output\_location) | Location of the data storage account |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | Key used to access storage account |
| <a name="output_primary_blob_url"></a> [primary\_blob\_url](#output\_primary\_blob\_url) | Primary URL for accessing the blob storage |
| <a name="output_primary_connection_string"></a> [primary\_connection\_string](#output\_primary\_connection\_string) | The connection string for the storage account |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
| <a name="output_secondary_access_key"></a> [secondary\_access\_key](#output\_secondary\_access\_key) | Key used to access storage account |
| <a name="output_share_id"></a> [share\_id](#output\_share\_id) | List of file share IDs |
| <a name="output_storage_id"></a> [storage\_id](#output\_storage\_id) | Output of the storage account resource id |
| <a name="output_storage_name"></a> [storage\_name](#output\_storage\_name) | Name of the data storage account |
