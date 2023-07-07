# azure-defender-for-cloud

## Overview

This terraform module will configure/ manage Microsoft Defender for Cloud (per subscription).

The configuration set by this module is based on the [HLD](https://hiscox.atlassian.net/wiki/spaces/II/pages/3590816342/INFHLD+-+Defender+for+Cloud) and [LLD](https://hiscox.atlassian.net/wiki/spaces/II/pages/3608772704/INFLLD+-+Defender+for+Cloud)

> Microsoft Defender for Cloud is a Cloud Security Posture Management (CSPM) and cloud workload protection solution.

## Defender for Cloud workload protection plans (azurerm\_security\_center\_subscription\_pricing)
The module will, by default, configure all Defender for Cloud workload protection plans to use the Standard tier.
> Be aware that this will incur a financial cost.

The module will accept a `defender_plans` map as an override to the default to specifically enable individual plans.

## Agents Auto Provisioning (azurerm\_security\_center\_auto\_provisioning)
Defender for Cloud collects data from Azure resources to monitor for security vulnerabilities and threats.
The original method of data collection (& the only method supported by terraform in 2022) is collected using the Log Analytics agent (aka Microsoft Management Agent (MMA)), which reads various security-related configurations and event logs from the machine and copies the data to your workspace for analysis.
To enable this feature with this module set the `enable_security_center_auto_provisioning = "On"` variable.

However, after a review of the MMA agent, and in the knowledge that the MMA agent is to be retired on 31 August 2024, it was decided that the newer Azure Monitor Agent (AMA) should be used in conjunction with Data Collection Rules to gather security information for virtual machines. It is therefore recommended **not** to enable auto-provisioning.

## Security contacts (azurerm\_security\_center\_contact)
The module will configure the subscription security contact information. This will define who will get email notifications from Defender for Cloud for the subscription.

## Security Center API settings/ Integrations (azurerm\_security\_center\_setting)
This module provides support to allow Microsoft Defender for Cloud Apps (MCAS) and Microsoft Defender for Endpoint (WDATP) to access my data.

Microsoft Cloud App Security, or MCAS, is a tool that you can use to achieve security monitoring and data security for applications. MCAS serves as a Cloud Access Security Broker, or CASB.

Windows Defender ATP data access (WDATP) integration brings Endpoint Detection and Response (EDR) capabilities within Defender for Cloud. This integration helps to spot abnormalities, detect and respond to advanced attacks on Windows server endpoints monitored by Azure Defender for Cloud.

By default, this module will enable both setting. These features can be controlled using the `mcas_setting` and `wdatp_name` booleans.

## Defender for Cloud workspace (azurerm\_security\_center\_workspace)
This module assumes that a central Log Analytics Workspace (with associated solutions) is available and will be used as the destination for Defender for Cloud logs.

It is possible to specify an alternate worspace by passing in valid 'log\_analytics\_workspace\_id'

## Continuous Export (azurerm\_security\_center\_automation)
The continuous export settings (which are kept in a hidden microsoft.security/automation resource) are to enable the collection of DfC security-related data types. The following settings will be used:
* Secure Score - Overall score, Control score
* Security Alerts - Low, Medium, High
* Regulatory Compliance - All standards selected

## Example

```terraform
module "azure-defender-for-cloud" {
  source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-defender-for-cloud"
  environment = "devtest"
  application = "security"
  location    = "northeurope"

  security_center_contacts = {
    email               = "john.doe@hiscox.com" # must be a valid email address
    alert_notifications = true
    alerts_to_admins    = true
  }
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
| [azurerm_resource_group.dfc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_security_center_auto_provisioning.dfc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_auto_provisioning) | resource |
| [azurerm_security_center_automation.dfc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_automation) | resource |
| [azurerm_security_center_contact.dfc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_contact) | resource |
| [azurerm_security_center_setting.mcas](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_setting) | resource |
| [azurerm_security_center_setting.wdatp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_setting) | resource |
| [azurerm_security_center_subscription_pricing.dfc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_subscription_pricing) | resource |
| [azurerm_security_center_workspace.dfc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_workspace) | resource |
| [time_static.t](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application | `string` | n/a | yes |
| <a name="input_defender_plans"></a> [defender\_plans](#input\_defender\_plans) | Map of Defender for Cloud workload protection plans to enable. Key is the workload protection plan, value is the pricing tier to use. Possible values are Free and Standard | `map(string)` | <pre>{<br>  "AppServices": "Standard",<br>  "Arm": "Standard",<br>  "Containers": "Standard",<br>  "Dns": "Standard",<br>  "KeyVaults": "Standard",<br>  "OpenSourceRelationalDatabases": "Standard",<br>  "SqlServerVirtualMachines": "Standard",<br>  "SqlServers": "Standard",<br>  "StorageAccounts": "Standard",<br>  "VirtualMachines": "Standard"<br>}</pre> | no |
| <a name="input_enable_security_center_auto_provisioning"></a> [enable\_security\_center\_auto\_provisioning](#input\_enable\_security\_center\_auto\_provisioning) | Setting to enable/ disable agent auto-provisioning on Virtual Machines in the subscription. Note that it is recommended not to use this feature in favour of using the Azure Monitor Agent with Data Collection Rules | `string` | `"Off"` | no |
| <a name="input_enable_security_center_automation"></a> [enable\_security\_center\_automation](#input\_enable\_security\_center\_automation) | Boolean flag to enable/ disable automation (Continuous Export) | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. Used as a tag and in naming the resource group | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The region resources will be deployed to | `string` | `"northeurope"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics Workspace Resource ID | `string` | `"/subscriptions/bab9ed05-2c6e-4631-a0cf-7373c33838cc/resourceGroups/production-security-dfc-northeurope/providers/Microsoft.OperationalInsights/workspaces/production-security-logworkspace-northeurope"` | no |
| <a name="input_mcas_setting"></a> [mcas\_setting](#input\_mcas\_setting) | Allow Microsoft Defender for Cloud Apps to access my data | `bool` | `true` | no |
| <a name="input_security_center_contacts"></a> [security\_center\_contacts](#input\_security\_center\_contacts) | Manages the subscription security contact | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_wdatp_setting"></a> [wdatp\_setting](#input\_wdatp\_setting) | Allow Microsoft Defender for Endpoint to access my data | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agent_auto_provisioning_setting"></a> [agent\_auto\_provisioning\_setting](#output\_agent\_auto\_provisioning\_setting) | The Defender for Cloud Auto Provisioning status |
| <a name="output_azure_subscription"></a> [azure\_subscription](#output\_azure\_subscription) | Name of the subscription |
| <a name="output_mcas_setting"></a> [mcas\_setting](#output\_mcas\_setting) | Allow Microsoft Defender for Cloud Apps to access my data? |
| <a name="output_subscription_security_contact"></a> [subscription\_security\_contact](#output\_subscription\_security\_contact) | The subscription security contact |
| <a name="output_wdatp_setting"></a> [wdatp\_setting](#output\_wdatp\_setting) | Allow Microsoft Defender for Endpoint to access my data? |
