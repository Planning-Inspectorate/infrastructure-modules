# azure-event-hub

This directory contains code that is used for deploying and Event Hub Namespace an associated Event Hubs

## How To Use

### Basic

```terraform
module "event_hub" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-event-hub"
  environment = "dev"
  application = "app"
  location    = "northeurope"
  event_hubs  = [
    {
      name = "first"
    }
  ]
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
| <a name="requirement_random"></a> [random](#requirement\_random) | >=3, < 4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.7, < 1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |
| <a name="provider_random"></a> [random](#provider\_random) | >=3, < 4 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_eventhub.eh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) | resource |
| [azurerm_eventhub_namespace.ehn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |
| [azurerm_eventhub_namespace_authorization_rule.namespace_auth_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace_authorization_rule) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_string.rnd](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_auto_inflate"></a> [auto\_inflate](#input\_auto\_inflate) | Auto scaling of namespace | `bool` | `false` | no |
| <a name="input_capture_description"></a> [capture\_description](#input\_capture\_description) | Details of a storage account where data should be streamed to for long term storage | `map(any)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_event_hubs"></a> [event\_hubs](#input\_event\_hubs) | A list of event hubs to be associated with the namespace. Each map must have a key called name. Sensible defaults are merged into this in locals.tf which you can override in your map | `list(map(any))` | `[]` | no |
| <a name="input_ip_rules"></a> [ip\_rules](#input\_ip\_rules) | A list of IP masks which source traffic should be permitted to access the namespace | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_max_throughput_units"></a> [max\_throughput\_units](#input\_max\_throughput\_units) | If auto\_inflate is true this specifies the maximum number of throughput units. Valid values between 1 and 20 | `number` | `2` | no |
| <a name="input_namespace_authorization_rule_listen"></a> [namespace\_authorization\_rule\_listen](#input\_namespace\_authorization\_rule\_listen) | Grants listen access on the auth rule | `bool` | `true` | no |
| <a name="input_namespace_authorization_rule_manage"></a> [namespace\_authorization\_rule\_manage](#input\_namespace\_authorization\_rule\_manage) | Grants manage access on the auth rule. Listen and send must both be true if this is set to true | `bool` | `false` | no |
| <a name="input_namespace_authorization_rule_send"></a> [namespace\_authorization\_rule\_send](#input\_namespace\_authorization\_rule\_send) | Grants send access on the auth rule | `bool` | `false` | no |
| <a name="input_namespace_capacity"></a> [namespace\_capacity](#input\_namespace\_capacity) | Specifies the Capacity / Throughput Units for a Standard SKU namespace | `number` | `2` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The Sku of the event hub namespace. Either Basic, Standard or Premium | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_vnet_rules"></a> [vnet\_rules](#input\_vnet\_rules) | A list of subnet IDs which should be permitted access to the namespace | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_event_hub_ids"></a> [event\_hub\_ids](#output\_event\_hub\_ids) | List of event hub IDs |
| <a name="output_namespace_id"></a> [namespace\_id](#output\_namespace\_id) | The ID of the namespace |
| <a name="output_namespace_name"></a> [namespace\_name](#output\_namespace\_name) | The name of the namespace |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
