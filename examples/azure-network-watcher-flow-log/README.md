# azure-network-watcher-flow-log

This directory contains code that will deploy a Network watcher Flow log.

## Purpose

The Network Watcher Flow Log catches all traffic that passes through the Network Security Group (NSG) and writes it to
a Storage Account and Log Analytics Workspace. This can then be queried through Log Analytics query language to return
a full insight into what is accessing the resources behind the NSG. This could be VMs, Application Gateways (if mounted
on a subnet), storage account (if mounted), etc. Anything communicating with items protected by the NSG would be tracked
and can be reported on.

## Advantages

- Combined with an organised NSG rule set (see examples/network-flow-nsg/nsg\_bu\_rules.tf for a sample) this can be very powerfull
- As it tracks traffic at the NSG level, this can traffic traffic within a subnet between two VMs (assuming one at least has NSG)

## Disadvantages

- The log Analytics agent does acrue significant cost over time so this should ideally be used for investigative purposes and then disabled.

## How To Deploy and Use

### Default Deployment

```terraform
module "template" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-network-watcher-flow-log"
  environment = "dev"
  application = "app"
  location    = "northeurope"
  tags        = local.tags

  log_analytics_workspace_resource_group_name = "law-rg"
  log_analytics_workspace_name                = "law1"
  network_security_group_id                   = "nsg1"
  network_watcher_name                        = "NetworkWatcher_northeurope"
  network_watcher_resource_group_name         = ""
  storage_account_id                          = "sa1"
}
```

### Useful Flow Log Queries

```
// Reports on number of hits of NSG per rule
AzureNetworkAnalytics_CL
| where NSGRule_s != ""
| extend LoadBalancer  = (split(LoadBalancer2_s, '/'))[2]
| summarize count(NSGRule_s) by NSGRule_s,DestPort_d,L7Protocol_s,FlowStatus_s,tostring(LoadBalancer)
```

```
// Same query but graphable
AzureNetworkAnalytics_CL
| where NSGRule_s != ""
| summarize count() by NSGRule_s
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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2, < 3 |
| <a name="provider_time"></a> [time](#provider\_time) | >=0.7, < 1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_watcher_flow_log.flow_log](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_watcher_flow_log) | resource |
| [azurerm_network_watcher_flow_log.flow_log_simple](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_watcher_flow_log) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_analytics"></a> [analytics](#input\_analytics) | Check whether the log analytics element of the flow logs is deployed | `bool` | `true` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_flow_log_name"></a> [flow\_log\_name](#input\_flow\_log\_name) | The name of the flow log | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of the log analytics workspace | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | Resource Group of the log analytics workspace | `string` | n/a | yes |
| <a name="input_network_security_group_id"></a> [network\_security\_group\_id](#input\_network\_security\_group\_id) | Name of the nsg where logs will be captured from | `string` | n/a | yes |
| <a name="input_network_watcher_name"></a> [network\_watcher\_name](#input\_network\_watcher\_name) | Name of the network watcher | `string` | n/a | yes |
| <a name="input_network_watcher_resource_group_name"></a> [network\_watcher\_resource\_group\_name](#input\_network\_watcher\_resource\_group\_name) | Resource Group of the network watcher | `string` | n/a | yes |
| <a name="input_nsg_port"></a> [nsg\_port](#input\_nsg\_port) | Frequency of updates to logs. Acceptable values are 60 or 10 (minutes) | `string` | `"60"` | no |
| <a name="input_reporting_interval"></a> [reporting\_interval](#input\_reporting\_interval) | Frequency of updates to logs. Acceptable values are 60 or 10 (minutes) | `string` | `"60"` | no |
| <a name="input_retention_duration"></a> [retention\_duration](#input\_retention\_duration) | duration to keep logs in storage account | `string` | `2` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | Name of the storage account for storing logs | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_watcher_id"></a> [network\_watcher\_id](#output\_network\_watcher\_id) | Network watcher Flow ID |
