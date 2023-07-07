/*
    Terraform configuration file defining provider configuration
*/
locals {
  # list(map) of baselines
  log_alert_baselines = [
    {
      name        = "manual-changes-to-resources"
      description = "Alert if manual changes are made to resources"
      query       = <<-QUERY
  AzureActivity 
  | where OperationNameValue contains '/WRITE'
  | where Authorization !contains '"principalType": "ServicePrincipal"'
  | where parse_json(tostring(parse_json(Authorization).evidence)).principalType <> "ServicePrincipal"
  | where _ResourceId !contains 'poc'
  | order by TimeGenerated desc 
QUERY
      severity    = 3
      frequency   = 15
      time_window = 30
      throttling  = 15
      operator    = "GreaterThan"
      threshold   = 0
    },
    {
      name        = "resource-failures"
      description = "Alert if services or resources report diagnostic failures"
      query       = <<-QUERY
  AzureDiagnostics
  | where ResultType == 'Failed'
  | order by TimeGenerated desc
QUERY
      severity    = 3
      frequency   = 15
      time_window = 30
      throttling  = 15
      operator    = "GreaterThan"
      threshold   = 0
    },
    {
      name        = "av-threat-detected"
      description = "Alerts on detected faults in Microsoft AV"
      query       = <<-QUERY
  ProtectionStatus
  | where ThreatStatusRank > 199 and ThreatStatusRank != 470
  | order by TimeGenerated desc
  QUERY
      severity    = 3
      frequency   = 15
      time_window = 30
      throttling  = 15
      operator    = "GreaterThan"
      threshold   = 0
    },
    {
      name        = "aks-errors"
      description = "Alert if Kubernetes reports an error for a namespaced resource"
      query       = <<-QUERY
  KubeEvents
  | where KubeEventType != 'Warning' and KubeEventType != 'Normal'
  | where not(isempty(Namespace))
  | order by TimeGenerated desc
  QUERY
      severity    = 3
      frequency   = 15
      time_window = 30
      throttling  = 15
      operator    = "GreaterThan"
      threshold   = 0
    },
    {
      name        = "aks-billable-usage"
      description = "Configure excessive billable usage alerts for namespaces in Kubernetes (Size in Gb/day)"
      query       = <<-QUERY
  ContainerLog
  | join(KubePodInventory | where TimeGenerated > startofday(ago(1d)))
  on ContainerID
  | where TimeGenerated > startofday(ago(1d))
  | summarize Total=sum(_BilledSize)/ 1000000000 by bin(TimeGenerated, 1d), Namespace
  | where Total > 1
  | order by TimeGenerated desc
  QUERY
      severity    = 3
      frequency   = 15
      time_window = 30
      throttling  = 15
      operator    = "GreaterThan"
      threshold   = 1
    },
    {
      name        = "kv-forbidden-access-request"
      description = "Reports on Forbidden (403) requests to Key Vault"
      query       = <<-QUERY
  AzureDiagnostics
  | where ResultSignature == 'Forbidden'
  | where ResultDescription !contains_cs "Operation get is not allowed on a disabled"
  | order by TimeGenerated desc
  QUERY
      severity    = 3
      frequency   = 15
      time_window = 30
      throttling  = 15
      operator    = "GreaterThan"
      threshold   = 2
    },
    {
      name        = "kv-privileged-actions"
      description = "Reports on Key Vault Sets, Updates and Deletes"
      query       = <<-QUERY
  AzureDiagnostics
  | where ResourceProvider == 'MICROSOFT.KEYVAULT'
  | where OperationName contains_cs "Delete" or OperationName contains_cs 'Update'
  | order by TimeGenerated desc
  QUERY
      severity    = 3
      frequency   = 15
      time_window = 30
      throttling  = 15
      operator    = "GreaterThan"
      threshold   = 0
    }
  ]
  # produce a map of baselines combined with extra user fed alerts where name is the key
  log_alerts = { for i in concat(local.log_alert_baselines, var.user_defined_alerts) : i.name => i }
  # if an override list is supplied turn that into a map where name is key
  log_alerts_override = { for i in var.override_alerts : i.name => i }
}
