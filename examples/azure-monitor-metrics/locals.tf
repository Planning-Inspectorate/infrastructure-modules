/*
    Terraform configuration file defining provider configuration
*/
locals {
  tags = merge(
    tomap({
      repo    = "https://dev.azure.com/hiscox/gp-psg/_git/terraform-modules",
      created = time_static.t.rfc3339
    }),
    var.tags,
  )

  # This local is the config of all the alerts to be applied to the target resource - if valid for their type
  # It's a local so that it can refer to other variable inputs, for thresholds etc if required
  # Or they can be hard-coded in the definition if preferred
  # It does make an assumption that the metric namespace will always match a resource type
  # This may have to change if further testing proves it incorrect
  # It also currently assumes that all alerts configured will be sent to the same action group

  # To add more default definitions, simply add entries in this map of maps, including required attributes
  # Also, config specific definitions in the variable var.alert_definitions will be merged with this block
  baseline_alert_definitions = [
    {
      name        = "vm-cpu"
      description = "Action will be triggered when % CPU utilisation is greater than 90."
      namespace   = "Microsoft.Compute/virtualMachines"
      metric_name = "Percentage CPU"
      aggregation = "Average"
      operator    = "GreaterThan"
      threshold   = "90"
      severity    = 1
      frequency   = "PT1M"
      window_size = "PT5M"
    },
    {
      name        = "public-ip-ddos"
      description = "Action will be triggered when DDoS count is greater than 0."
      namespace   = "Microsoft.Network/publicipaddresses"
      metric_name = "IfUnderDDoSAttack"
      aggregation = "Average"
      operator    = "GreaterThan"
      threshold   = "0"
      severity    = 1
      frequency   = "PT5M"
      window_size = "PT15M"
    },
    {
      name        = "public-ip-availability"
      description = "Action will be triggered when average availability is less than 100."
      namespace   = "Microsoft.Network/publicipaddresses"
      metric_name = "VipAvailability"
      aggregation = "Average"
      operator    = "LessThan"
      threshold   = "100"
    },
    {
      name        = "storage-availability"
      description = "Action will be triggered when average availability is less than 100."
      namespace   = "Microsoft.Storage/storageAccounts"
      metric_name = "Availability"
      aggregation = "Average"
      operator    = "LessThan"
      threshold   = "100"
    },
    # This one is odd - would expect zero errors, but in actual fact there's quite a high baseline count,
    # so a threshold of zero seems optimistic - perhaps a more sensible threshold can be identified.
    # {
    #   name        = "storage-transactions"
    #   description = "Action will be triggered when error count is greater than 0."
    #   namespace   = "Microsoft.Storage/storageAccounts"
    #   metric_name = "Transactions"
    #   aggregation = "Average"
    #   operator    = "GreaterThan"
    #   threshold   = "0"
    #   dimensions  = "ResponseType,Include,ClientOtherError"
    # },
    {
      name        = "keyvault-availability"
      description = "Action will be triggered when average availability is less than 100."
      namespace   = "Microsoft.KeyVault/vaults"
      metric_name = "Availability"
      aggregation = "Average"
      operator    = "LessThan"
      threshold   = "100"
    },
    {
      name        = "appgw-unhealthyhost"
      description = "Action will be triggered when average unhealthy backend host count is greater than 0."
      namespace   = "Microsoft.Network/applicationGateways"
      metric_name = "UnhealthyHostCount"
      aggregation = "Average"
      operator    = "GreaterThan"
      threshold   = "0"
    },
    {
      name        = "appgw-failedreq"
      description = "Action will be triggered when failed request count is greater than 0."
      namespace   = "Microsoft.Network/applicationGateways"
      metric_name = "FailedRequests"
      aggregation = "Total"
      operator    = "GreaterThan"
      threshold   = "0"
    },
    {
      name        = "appgw-totaltime"
      description = "Action will be triggered when average AppGw total request time is greater than 3000ms."
      namespace   = "Microsoft.Network/applicationGateways"
      metric_name = "ApplicationGatewayTotalTime"
      aggregation = "Average"
      operator    = "GreaterThan"
      threshold   = "3000"
    },
    {
      name        = "sqldb-failedconn"
      description = "Action will be triggered when total failed connection count is greater than 0."
      namespace   = "Microsoft.Sql/servers/databases"
      metric_name = "connection_failed"
      aggregation = "Total"
      operator    = "GreaterThan"
      threshold   = "0"
    },
    {
      name        = "sqldb-blockedfw"
      description = "Action will be triggered when total firewall block count is greater than 0."
      namespace   = "Microsoft.Sql/servers/databases"
      metric_name = "blocked_by_firewall"
      aggregation = "Total"
      operator    = "GreaterThan"
      threshold   = "0"
    },
    {
      name        = "sqldb-deadlock"
      description = "Action will be triggered when total deadlock count is greater than 0."
      namespace   = "Microsoft.Sql/servers/databases"
      metric_name = "deadlock"
      aggregation = "Total"
      operator    = "GreaterThan"
      threshold   = "0"
    },
    {
      name        = "sqldb-dtuconsumption"
      description = "Action will be triggered when average DTU consumption is greater than 70."
      namespace   = "Microsoft.Sql/servers/databases"
      metric_name = "dtu_consumption_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      threshold   = "70"
    },
    {
      name        = "webapp-4xx"
      description = "Action will be triggered when 4xx errors is greater than 0."
      namespace   = "Microsoft.Web/sites"
      metric_name = "Http4xx"
      aggregation = "Average"
      operator    = "GreaterThan"
      threshold   = "0"
    },
    {
      name        = "webapp-5xx"
      description = "Action will be triggered when 5xx errors is greater than 0."
      namespace   = "Microsoft.Web/sites"
      metric_name = "Http5xx"
      aggregation = "Average"
      operator    = "GreaterThan"
      threshold   = "0"
    },
    {
      name        = "webapp-response"
      description = "Action will be triggered when HTTP response time is greater than 30 seconds."
      namespace   = "Microsoft.Web/sites"
      metric_name = "HttpResponseTime"
      aggregation = "Average"
      operator    = "GreaterThan"
      threshold   = "30"
    },
    {
      name        = "serverfarm-cpu"
      description = "Action will be triggered when CPU usage is greater than 90%"
      namespace   = "Microsoft.Web/serverFarms"
      metric_name = "CpuPercentage"
      aggregation = "Average"
      operator    = "GreaterThan"
      threshold   = "90"
    },
    {
      name        = "datafactory-failed-triggers"
      description = "Action will be triggered when Data Factory failed triggers is greater than 0."
      namespace   = "Microsoft.DataFactory/factories"
      metric_name = "TriggerFailedRuns"
      aggregation = "Average"
      operator    = "GreaterThan"
      threshold   = "0"
    },
    {
      name        = "aks-disk-usage"
      description = "Action will be triggered when disk use is above 90%."
      namespace   = "Microsoft.ContainerService/managedClusters"
      metric_name = "node_disk_usage_percentage"
      aggregation = "Average"
      operator    = "GreaterThan"
      threshold   = "90"
    },
    {
      name        = "aks-unschedulable-pods"
      description = "Action will be triggered when unschedulable pods is greater than 0."
      namespace   = "Microsoft.ContainerService/managedClusters"
      metric_name = "cluster_autoscaler_unschedulable_pods_count"
      aggregation = "Average"
      operator    = "GreaterThan"
      threshold   = "0"
    },
    {
      name        = "aks-unschedulable-nodes"
      description = "Action will be triggered when unschedulable nodes is greater than 0."
      namespace   = "Microsoft.ContainerService/managedClusters"
      metric_name = "cluster_autoscaler_unneeded_nodes_count"
      aggregation = "Average"
      operator    = "GreaterThan"
      threshold   = "0"
    },
    {
      name        = "aks-cluster-health"
      description = "Action will be triggered when cluster health drops below 1."
      namespace   = "Microsoft.ContainerService/managedClusters"
      metric_name = "cluster_autoscaler_cluster_safe_to_autoscale"
      aggregation = "Average"
      operator    = "LessThan"
      threshold   = "1"
    },
    {
      name        = "load-balancer-health-probe-status"
      description = "Action will be triggered when health probe status drops below 100."
      namespace   = "Microsoft.Network/loadBalancers"
      metric_name = "DipAvailability"
      aggregation = "Average"
      operator    = "LessThan"
      threshold   = "100"
    },
    {
      name        = "load-balancer-data-path-availability"
      description = "Action will be triggered when availability drops below 100."
      namespace   = "Microsoft.Network/loadBalancers"
      metric_name = "VipAvailability"
      aggregation = "Average"
      operator    = "LessThan"
      threshold   = "100"
    },
    {
      name        = "private-dns-zone-record-capacity-utilization"
      description = "Action will be triggered when utilization reaches 95%."
      namespace   = "Microsoft.Network/privateDnsZones"
      metric_name = "RecordSetCapacityUtilization"
      aggregation = "Maximum"
      operator    = "GreaterThan"
      threshold   = "95"
    },
    {
      name        = "service-bus-server-errors"
      description = "Action will be triggered when server errors rise above 0."
      namespace   = "Microsoft.ServiceBus/namespaces"
      metric_name = "ServerErrors"
      aggregation = "Total"
      operator    = "GreaterThan"
      threshold   = "0"
    },
    {
      name        = "service-bus-user-errors"
      description = "Action will be triggered when user errors rise above 0."
      namespace   = "Microsoft.ServiceBus/namespaces"
      metric_name = "UserErrors"
      aggregation = "Total"
      operator    = "GreaterThan"
      threshold   = "0"
    },
    {
      name        = "api-failed-requests"
      description = "Count of HTTP requests marked as failed. In most cases these are requests with a response code >= 400 and not equal to 401."
      namespace   = "Microsoft.Insights/components"
      metric_name = "requests/failed"
      aggregation = "Count"
      operator    = "GreaterThan"
      threshold   = "0"
    }
  ]

  # Combine baseline with var.alert_definitions
  alert_definitions = concat(local.baseline_alert_definitions, var.alert_definitions)

  # This block to set default values if not provided in local.baseline_alert_definitions or var.alert_definitions
  alert_defaults = {
    frequency   = "PT15M"
    dimensions  = ""
    severity    = 3
    window_size = "PT1H"
  }

  # This merges each alert definition with the defaults block to ensure that all required values are present
  full_alert_definitions = [for d in local.alert_definitions : merge(local.alert_defaults, d)]
  # filter the alerts based on resource type
  matching_alerts = [for d in local.full_alert_definitions : d if d.namespace == var.target_resource_type]

  # This local block creates a flattened list of maps, populating all the definitions above
  # with the details of the eligible alerts.
  # By "eligible", we mean resources of types for which alert definitions exist above.
  # The output of this is fed to the for_each attribute of the alert resource.
  alerts = { for v in local.matching_alerts : v.name => {
    description = v.description
    namespace   = v.namespace
    metric_name = v.metric_name
    aggregation = v.aggregation
    operator    = v.operator
    threshold   = v.threshold
    dimensions  = v.dimensions
    frequency   = v.frequency
    severity    = v.severity
    window_size = v.window_size
    }
  }
}
