/*
* # azure-defender-for-cloud
* 
* ## Overview
*
* This terraform module will configure/ manage Microsoft Defender for Cloud (per subscription).
*
* The configuration set by this module is based on the [HLD](https://hiscox.atlassian.net/wiki/spaces/II/pages/3590816342/INFHLD+-+Defender+for+Cloud) and [LLD](https://hiscox.atlassian.net/wiki/spaces/II/pages/3608772704/INFLLD+-+Defender+for+Cloud)
* 
* > Microsoft Defender for Cloud is a Cloud Security Posture Management (CSPM) and cloud workload protection solution.
*
* ## Defender for Cloud workload protection plans (azurerm_security_center_subscription_pricing)
* The module will, by default, configure all Defender for Cloud workload protection plans to use the Standard tier. 
* > Be aware that this will incur a financial cost.
*
* The module will accept a `defender_plans` map as an override to the default to specifically enable individual plans.
*
* ## Agents Auto Provisioning (azurerm_security_center_auto_provisioning)
* Defender for Cloud collects data from Azure resources to monitor for security vulnerabilities and threats. 
* The original method of data collection (& the only method supported by terraform in 2022) is collected using the Log Analytics agent (aka Microsoft Management Agent (MMA)), which reads various security-related configurations and event logs from the machine and copies the data to your workspace for analysis.
* To enable this feature with this module set the `enable_security_center_auto_provisioning = "On"` variable.
*
* However, after a review of the MMA agent, and in the knowledge that the MMA agent is to be retired on 31 August 2024, it was decided that the newer Azure Monitor Agent (AMA) should be used in conjunction with Data Collection Rules to gather security information for virtual machines. It is therefore recommended **not** to enable auto-provisioning.
*
* ## Security contacts (azurerm_security_center_contact)
* The module will configure the subscription security contact information. This will define who will get email notifications from Defender for Cloud for the subscription.
*
* ## Security Center API settings/ Integrations (azurerm_security_center_setting)
* This module provides support to allow Microsoft Defender for Cloud Apps (MCAS) and Microsoft Defender for Endpoint (WDATP) to access my data. 
*
* Microsoft Cloud App Security, or MCAS, is a tool that you can use to achieve security monitoring and data security for applications. MCAS serves as a Cloud Access Security Broker, or CASB.
*
* Windows Defender ATP data access (WDATP) integration brings Endpoint Detection and Response (EDR) capabilities within Defender for Cloud. This integration helps to spot abnormalities, detect and respond to advanced attacks on Windows server endpoints monitored by Azure Defender for Cloud.
*
* By default, this module will enable both setting. These features can be controlled using the `mcas_setting` and `wdatp_name` booleans.
*
* ## Defender for Cloud workspace (azurerm_security_center_workspace)
* This module assumes that a central Log Analytics Workspace (with associated solutions) is available and will be used as the destination for Defender for Cloud logs.
* 
* It is possible to specify an alternate worspace by passing in valid 'log_analytics_workspace_id'
*
* ## Continuous Export (azurerm_security_center_automation)
* The continuous export settings (which are kept in a hidden microsoft.security/automation resource) are to enable the collection of DfC security-related data types. The following settings will be used:
* * Secure Score - Overall score, Control score
* * Security Alerts - Low, Medium, High
* * Regulatory Compliance - All standards selected
*
* ## Example
*
* ```terraform
* module "azure-defender-for-cloud" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-defender-for-cloud"
*   environment = "devtest"
*   application = "security"
*   location    = "northeurope"
*
*   security_center_contacts = {
*     email               = "john.doe@hiscox.com" # must be a valid email address
*     alert_notifications = true
*     alerts_to_admins    = true
*   }
* }
*
* ```
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/


resource "azurerm_resource_group" "dfc" {
  name     = "${var.environment}-${var.application}-dfc-${var.location}"
  location = var.location
  tags     = local.tags
}
resource "azurerm_security_center_subscription_pricing" "dfc" {
  for_each      = var.defender_plans
  resource_type = each.key
  tier          = each.value
}

resource "azurerm_security_center_auto_provisioning" "dfc" {
  count          = var.enable_security_center_auto_provisioning == "On" ? 1 : 0
  auto_provision = var.enable_security_center_auto_provisioning
}

resource "azurerm_security_center_workspace" "dfc" {
  count        = var.enable_security_center_auto_provisioning == "On" ? 1 : 0
  scope        = data.azurerm_subscription.current.id
  workspace_id = var.log_analytics_workspace_id
}
resource "azurerm_security_center_contact" "dfc" {
  email               = lookup(var.security_center_contacts, "email", "noreply@hiscox.com")
  phone               = lookup(var.security_center_contacts, "phone", null)
  alert_notifications = lookup(var.security_center_contacts, "alert_notifications", true)
  alerts_to_admins    = lookup(var.security_center_contacts, "alerts_to_admins", true)
}

resource "azurerm_security_center_setting" "mcas" {
  count        = var.mcas_setting ? 1 : 0
  setting_name = "MCAS"
  enabled      = var.mcas_setting
}

resource "azurerm_security_center_setting" "wdatp" {
  count        = var.wdatp_setting ? 1 : 0
  setting_name = "WDATP"
  enabled      = var.wdatp_setting
}

resource "azurerm_security_center_automation" "dfc" {
  count               = var.enable_security_center_automation ? 1 : 0
  name                = "ExportToWorkspace"
  location            = azurerm_resource_group.dfc.location
  resource_group_name = azurerm_resource_group.dfc.name

  action {
    type        = "loganalytics"
    resource_id = var.log_analytics_workspace_id
  }

  source {
    event_source = "Assessments"
    rule_set {
      rule {
        property_path  = "type"
        operator       = "Contains"
        expected_value = "Microsoft.Security/assessments"
        property_type  = "String"
      }
    }
  }
  source {
    event_source = "Alerts"
    rule_set {
      rule {
        property_path  = "Severity"
        operator       = "Equals"
        expected_value = "high"
        property_type  = "String"
      }
      rule {
        property_path  = "Severity"
        operator       = "Equals"
        expected_value = "medium"
        property_type  = "String"
      }
      rule {
        property_path  = "Severity"
        operator       = "Equals"
        expected_value = "low"
        property_type  = "String"
      }
    }
  }
  source {
    event_source = "SubAssessments"
  }
  source {
    event_source = "SecureScores"
  }
  source {
    event_source = "SecureScoreControls"
  }
  source {
    event_source = "SecureScoresSnapshot"
  }
  source {
    event_source = "SecureScoreControlsSnapshot"
  }
  source {
    event_source = "RegulatoryComplianceAssessment"
  }
  source {
    event_source = "RegulatoryComplianceAssessmentSnapshot"
  }

  scopes = [
    "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  ]
}

