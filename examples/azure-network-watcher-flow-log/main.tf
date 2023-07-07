/**
* # azure-network-watcher-flow-log
* 
* This directory contains code that will deploy a Network watcher Flow log. 
*
* ## Purpose
* 
* The Network Watcher Flow Log catches all traffic that passes through the Network Security Group (NSG) and writes it to 
* a Storage Account and Log Analytics Workspace. This can then be queried through Log Analytics query language to return 
* a full insight into what is accessing the resources behind the NSG. This could be VMs, Application Gateways (if mounted 
* on a subnet), storage account (if mounted), etc. Anything communicating with items protected by the NSG would be tracked 
* and can be reported on.
* 
* ## Advantages
* 
* - Combined with an organised NSG rule set (see examples/network-flow-nsg/nsg_bu_rules.tf for a sample) this can be very powerfull
* - As it tracks traffic at the NSG level, this can traffic traffic within a subnet between two VMs (assuming one at least has NSG)
* 
* ## Disadvantages
* 
* - The log Analytics agent does acrue significant cost over time so this should ideally be used for investigative purposes and then disabled.
* 
* ## How To Deploy and Use
*
* ### Default Deployment
*
* ```terraform
* module "template" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-network-watcher-flow-log"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   tags        = local.tags
*   
*   log_analytics_workspace_resource_group_name = "law-rg"
*   log_analytics_workspace_name                = "law1"
*   network_security_group_id                   = "nsg1"
*   network_watcher_name                        = "NetworkWatcher_northeurope"
*   network_watcher_resource_group_name         = ""
*   storage_account_id                          = "sa1"
* }
* ```
* 
* ### Useful Flow Log Queries
*
* ```
* // Reports on number of hits of NSG per rule
* AzureNetworkAnalytics_CL 
* | where NSGRule_s != "" 
* | extend LoadBalancer  = (split(LoadBalancer2_s, '/'))[2]
* | summarize count(NSGRule_s) by NSGRule_s,DestPort_d,L7Protocol_s,FlowStatus_s,tostring(LoadBalancer)
* ```
* 
* ```
* // Same query but graphable
* AzureNetworkAnalytics_CL 
* | where NSGRule_s != "" 
* | summarize count() by NSGRule_s
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

resource "azurerm_network_watcher_flow_log" "flow_log" {
  count                     = var.analytics ? 1 : 0
  name                      = var.flow_log_name
  network_watcher_name      = var.network_watcher_name
  resource_group_name       = var.network_watcher_resource_group_name
  network_security_group_id = var.network_security_group_id
  storage_account_id        = var.storage_account_id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = var.retention_duration
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.law[0].workspace_id
    workspace_region      = var.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.law[0].id
    interval_in_minutes   = var.reporting_interval
  }
}

resource "azurerm_network_watcher_flow_log" "flow_log_simple" {
  count                     = var.analytics ? 0 : 1
  name                      = var.flow_log_name
  network_watcher_name      = var.network_watcher_name
  resource_group_name       = var.network_watcher_resource_group_name
  network_security_group_id = var.network_security_group_id
  storage_account_id        = var.storage_account_id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = var.retention_duration
  }
}
