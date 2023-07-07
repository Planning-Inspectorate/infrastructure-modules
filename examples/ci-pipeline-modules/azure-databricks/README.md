# azure-databricks

CI for databricks

## How To Update this README.md

* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and * output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | ~> 0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_databricks"></a> [databricks](#module\_databricks) | ../../azure-databricks | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_autoscale"></a> [autoscale](#input\_autoscale) | "The autoscale parameter block. Contains the minimum number of workers to which the cluster can scale down when underutilized and maximum number of workers to which the cluster can scale up when overloaded. max\_workers must be strictly greater than min\_workers.<br>autoscale = {<br>  autoscale\_min\_workers     = "min\_workers"<br>  autoscale\_max\_workers     = "max\_workers"<br>}" | `map(string)` | `null` | no |
| <a name="input_autotermination_minutes"></a> [autotermination\_minutes](#input\_autotermination\_minutes) | Automatically terminates the cluster after it is inactive for this time in minutes. If not set, this cluster will not be automatically terminated. If specified, the threshold must be between 10 and 10000 minutes. You can also set this value to 0 to explicitly disable automatic termination | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_node_type_id"></a> [node\_type\_id](#input\_node\_type\_id) | Any supported databricks\_node\_type id | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | The sku to use for the Databricks Workspace. Possible values are standard, premium, or trial. Changing this forces a new resource to be created | `string` | `"standard"` | no |
| <a name="input_spark_version"></a> [spark\_version](#input\_spark\_version) | Runtime version of the cluster. A list of available Spark versions can be retrieved by using the Runtime Versions API call or databricks clusters spark-versions CLI command. It is advised to use Cluster Policies to restrict list of versions for simplicity, while maintaining enough of control | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
