# azure-databricks

Provisions a Azure Databricks Service (Workspace and Cluster)

## How To Use

* Inputs should be refereced in a module to create your Databricks Workspace and Cluster of the sort: `module "azure_databricks" {...}`

```HCL

module "azure_databricks" {
 source                   = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-databricks"
 environment              = var.environment
 application              = var.application
 location                 = var.location
 sku                      = var.sku
 spark_version            = var.spark_version
 node_type_id             = var.node_type_id
 autotermination_minutes  = var.autotermination_minutes
 autoscale                = var.autoscale
 databricks_admin_users   = ["user1@example.com", "user2@example.com"]
 tags                     = var.tags
}
```

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and * output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2, < 3 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 0.3, < 1 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | >= 0.3, < 1 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_databricks_workspace.azurerm_databricks_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [databricks_cluster.databricks_cluster](https://registry.terraform.io/providers/databrickslabs/databricks/latest/docs/resources/cluster) | resource |
| [databricks_group_member.group_member_admin_users](https://registry.terraform.io/providers/databrickslabs/databricks/latest/docs/resources/group_member) | resource |
| [databricks_user.databricks_admin_users](https://registry.terraform.io/providers/databrickslabs/databricks/latest/docs/resources/user) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [databricks_group.databricks_admins_group](https://registry.terraform.io/providers/databrickslabs/databricks/latest/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_autoscale"></a> [autoscale](#input\_autoscale) | "The autoscale parameter block. Contains the minimum number of workers to which the cluster can scale down when underutilized and maximum number of workers to which the cluster can scale up when overloaded. max\_workers must be strictly greater than min\_workers.<br>autoscale = {<br>  autoscale\_min\_workers     = "min\_workers"<br>  autoscale\_max\_workers     = "max\_workers"<br>}" | `map(string)` | `null` | no |
| <a name="input_autotermination_minutes"></a> [autotermination\_minutes](#input\_autotermination\_minutes) | Automatically terminates the cluster after it is inactive for this time in minutes. If not set, this cluster will not be automatically terminated. If specified, the threshold must be between 10 and 10000 minutes. You can also set this value to 0 to explicitly disable automatic termination | `number` | n/a | yes |
| <a name="input_custom_parameters"></a> [custom\_parameters](#input\_custom\_parameters) | "The custom parameters block. The amp format must be:<br>custom\_parameters = {<br>  public\_subnet\_name     = "your\_public\_subnet\_name"<br>  private\_subnet\_name    = "your\_private\_subnet\_name"<br>  virtual\_network\_id     = "your\_virtual\_network\_id"<br>}" | `map(string)` | `{}` | no |
| <a name="input_databricks_admin_users"></a> [databricks\_admin\_users](#input\_databricks\_admin\_users) | This is the usernames of the given users and will be their form of access and identity | `list(string)` | `[]` | no |
| <a name="input_databricks_cluster_name"></a> [databricks\_cluster\_name](#input\_databricks\_cluster\_name) | The databricks cluster name this module should use. If not specified one will be created for you with name like: environment-application-databricks-location | `string` | `""` | no |
| <a name="input_databricks_workspace_name"></a> [databricks\_workspace\_name](#input\_databricks\_workspace\_name) | The databricks workspace name this module should use. If not specified one will be created for you with name like: environment-application-databricks-location | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_is_pinned"></a> [is\_pinned](#input\_is\_pinned) | Boolean value specifying if cluster is pinned | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_node_type_id"></a> [node\_type\_id](#input\_node\_type\_id) | Any supported databricks\_node\_type id | `string` | n/a | yes |
| <a name="input_num_workers"></a> [num\_workers](#input\_num\_workers) | The fixed size for the cluster. If both num\_workers and autoscale variable are present, the control plane prefers autoscale. | `number` | `null` | no |
| <a name="input_python_libraries"></a> [python\_libraries](#input\_python\_libraries) | List containing the Python Libraries to be installed in the Cluster | `list(string)` | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The sku to use for the Databricks Workspace. Possible values are standard, premium, or trial. Changing this forces a new resource to be created | `string` | `"standard"` | no |
| <a name="input_spark_conf"></a> [spark\_conf](#input\_spark\_conf) | Map with key-value pairs to fine tune Spark clusters | `map(string)` | `{}` | no |
| <a name="input_spark_version"></a> [spark\_version](#input\_spark\_version) | Runtime version of the cluster. A list of available Spark versions can be retrieved by using the Runtime Versions API call or databricks clusters spark-versions CLI command. It is advised to use Cluster Policies to restrict list of versions for simplicity, while maintaining enough of control | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_databricks_workspace_id"></a> [databricks\_workspace\_id](#output\_databricks\_workspace\_id) | The ID of the Databricks Workspace |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
