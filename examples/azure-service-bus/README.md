# azure-service-bus

This directory stands up a Service Bus instance.

## How To Use

### Service Bus with Queues

```terraform
module "sb" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-service-bus"
  environment = "dev"
  application = "app"
  location    = "northeurope"
  queues = [
    {
      name = "example1"
      lock_duration = "PT5M"
    },
    {
      name = "example2"
      max_delivery_count = 3
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
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_servicebus_namespace.sb_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace) | resource |
| [azurerm_servicebus_namespace_authorization_rule.sb_namespace_authorization](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace_authorization_rule) | resource |
| [azurerm_servicebus_namespace_network_rule_set.rs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace_network_rule_set) | resource |
| [azurerm_servicebus_queue.sb_queue](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue) | resource |
| [azurerm_servicebus_queue_authorization_rule.sb_queue_authorization](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue_authorization_rule) | resource |
| [azurerm_servicebus_topic.sb_topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_topic) | resource |
| [azurerm_servicebus_topic_authorization_rule.sb_topic_authorization](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_topic_authorization_rule) | resource |
| [random_string.rnd](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | Capacity size, must be 0 when sku is Standard, for Premium acceptable values are 1, 2, 4 or 8 | `map(number)` | <pre>{<br>  "Basic": 0,<br>  "Premium": 4,<br>  "Standard": 0<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_namespace_authorization_rule_listen"></a> [namespace\_authorization\_rule\_listen](#input\_namespace\_authorization\_rule\_listen) | Grants listen access on the auth rule | `bool` | `true` | no |
| <a name="input_namespace_authorization_rule_manage"></a> [namespace\_authorization\_rule\_manage](#input\_namespace\_authorization\_rule\_manage) | Grants manage access on the auth rule | `bool` | `false` | no |
| <a name="input_namespace_authorization_rule_send"></a> [namespace\_authorization\_rule\_send](#input\_namespace\_authorization\_rule\_send) | Grants send access on the auth rule | `bool` | `true` | no |
| <a name="input_network_rule_ips"></a> [network\_rule\_ips](#input\_network\_rule\_ips) | List of IP addresses or CIDR blocks which should be allowed access to the Service Bus namespace | `list(string)` | `[]` | no |
| <a name="input_network_rule_subnet_ids"></a> [network\_rule\_subnet\_ids](#input\_network\_rule\_subnet\_ids) | A list of subnet IDs which should be allowed access to the Service Bus namespace | `list(string)` | `[]` | no |
| <a name="input_queues"></a> [queues](#input\_queues) | "List of queues, each map must contain a name field. Optional parameters that can be overriden (defaults can be found under locals.tf):<br>{<br>  lock\_duration<br>  max\_size\_in\_megabytes<br>  requires\_duplicate\_detection<br>  requires\_session<br>  auto\_delete\_on\_idle<br>  default\_message\_ttl<br>  dead\_lettering\_on\_message\_expiration<br>  duplicate\_detection\_history\_time\_window<br>  max\_delivery\_count<br>  status<br>  enable\_batched\_operations<br>  listen<br>  send<br>  manage<br>}" | `list(map(any))` | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The target resource group this module should be deployed into. If not specified one will be created for you with name like: environment-application-template-location | `string` | `""` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | Tier of service bus | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | "List of topics, each map must contain a name field. Optional parameters that can be overriden (defaults can be found under locals.tf):<br>{<br>  status<br>  auto\_delete\_on\_idle<br>  default\_message\_ttl<br>  duplicate\_detection\_history\_time\_window<br>  enable\_batched\_operations<br>  enable\_express<br>  max\_size\_in\_megabytes<br>  requires\_duplicate\_detection<br>  support\_ordering<br>}" | `list(map(any))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Service Bus Namespace |
| <a name="output_namespace_auth_id"></a> [namespace\_auth\_id](#output\_namespace\_auth\_id) | ID of the namespace authorization rule |
| <a name="output_namespace_auth_primary_connection_string"></a> [namespace\_auth\_primary\_connection\_string](#output\_namespace\_auth\_primary\_connection\_string) | Primary connection string for the ServiceBus namespace authorization rule |
| <a name="output_namespace_auth_primary_key"></a> [namespace\_auth\_primary\_key](#output\_namespace\_auth\_primary\_key) | Primary key for accessing the namespace authorization rule |
| <a name="output_namespace_auth_secondary_connection_string"></a> [namespace\_auth\_secondary\_connection\_string](#output\_namespace\_auth\_secondary\_connection\_string) | Secondary connection string for the ServiceBus namespace authorization rule |
| <a name="output_namespace_auth_secondary_key"></a> [namespace\_auth\_secondary\_key](#output\_namespace\_auth\_secondary\_key) | Secondary key for accessing the namespace authorization rule |
| <a name="output_queue_ids"></a> [queue\_ids](#output\_queue\_ids) | List of queue IDs |
| <a name="output_queue_primary_connection_string"></a> [queue\_primary\_connection\_string](#output\_queue\_primary\_connection\_string) | List of primary connection strings for the ServiceBus queue |
| <a name="output_queue_primary_key"></a> [queue\_primary\_key](#output\_queue\_primary\_key) | List of primary keys for accessing the queue |
| <a name="output_queue_secondary_connection_string"></a> [queue\_secondary\_connection\_string](#output\_queue\_secondary\_connection\_string) | List of secondary connection strings for the ServiceBus queue |
| <a name="output_queue_secondary_key"></a> [queue\_secondary\_key](#output\_queue\_secondary\_key) | List of secondary keys for accessing the queue |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group where resources have been deployed to |
| <a name="output_root_namespace_primary_connection_string"></a> [root\_namespace\_primary\_connection\_string](#output\_root\_namespace\_primary\_connection\_string) | Root manager primary connection string for the ServiceBus namespace |
| <a name="output_root_namespace_primary_key"></a> [root\_namespace\_primary\_key](#output\_root\_namespace\_primary\_key) | Root manager primary key for accessing the namespace |
| <a name="output_root_namespace_secondary_connection_string"></a> [root\_namespace\_secondary\_connection\_string](#output\_root\_namespace\_secondary\_connection\_string) | Root manager secondary connection string for the ServiceBus namespace |
| <a name="output_root_namespace_secondary_key"></a> [root\_namespace\_secondary\_key](#output\_root\_namespace\_secondary\_key) | Root manager secondary key for accessing the namespace |
| <a name="output_topic_ids"></a> [topic\_ids](#output\_topic\_ids) | List of topic IDs |
| <a name="output_topic_primary_connection_string"></a> [topic\_primary\_connection\_string](#output\_topic\_primary\_connection\_string) | List of primary connection strings for the ServiceBus topic |
| <a name="output_topic_primary_key"></a> [topic\_primary\_key](#output\_topic\_primary\_key) | List of primary keys for accessing the topic |
| <a name="output_topic_secondary_connection_string"></a> [topic\_secondary\_connection\_string](#output\_topic\_secondary\_connection\_string) | List of secondary connection strings for the ServiceBus topic |
| <a name="output_topic_secondary_key"></a> [topic\_secondary\_key](#output\_topic\_secondary\_key) | List of secondary keys for accessing the topic |
