/**
* # keyvault-diagnostics
* 
* A terraform config to show how to create external resources for keyvault diagnostics requirement
* 
* ## Pipelines
* 
* There are two supported approaches for deploying infrastructure resources through terraform. The first is known as `PSDeployTools` and is simply a powershell module for wrapping around the terraform binary. It allows you to call terraform under different modes (apply/destroy etc.) and makes use of REST calls for storing state files in Artifactory with optional encryption.
* 
* The second uses a Go library called Terratest, developed by Gruntwork. You write a Go test file and invoke `go test` at its location. This allows you to excute terraform under different modes allowing for persisted infrastructure while making use of deffered calls to properly CI infrastructure (build it, test it, destroy it). This template has an example Go test file under `environments/`. It does expect certain environment variables to be avaialble (for auth and state storage) but it will tell you when one is missing. It can be used as a template for deploying real infrastructure as you can target different deployments through a `VARFILE` environment variable - meaning that the structure of your test and what gets tested is the same across all environments. You can also manage the lifecycle of infrastructure as the terraform apply and destroy operations are managed through further environment variables, so you can pipleine different stages.
*
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*
* ## Diagrams
*
* ![image info](./diagrams/design.png)
*
* Unfortunately a number of tools that can parse Terraform code/statefiles and generate architetcure diagrams are limited and most are in their infancy. The built in `terraform graph` is only really useful for looking at dependencies and is too verbose to be considered a diagram on an environment.
*
* We can however turn this on its head and look at using deployed resources to produce a diagram as a stop gap. AzViz is a tool which takes one or more resource groups as input and it will parse their contents and produce a more architecture-like diagram. It will also work out the relation between different resources. Check out all its features [here](https://github.com/PrateekKumarSingh/AzViz). To use it to store a diagram post deployment:
*
* ```pwsh
* Connect-AzAccount
* Set-AzContext -Subscription 'xxxx-xxxx'
* Export-AzViz -ResourceGroup my-resource-group-1, my-rg-2 -Theme light -OutputFormat png -OutputFilePath 'diagrams/design.png' -CategoryDepth 1 -LabelVerbosity 2
* ```
*/

resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-${var.application}-diag-${var.location}"
  location = var.location
  tags     = local.tags
}

module "keyvault" {
  source              = "../../azure-keyvault"
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  access_policies     = var.access_policies
  tags                = local.tags
}

module "law" {
  source              = "../../azure-log-analytics"
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment
  application         = var.application
  location            = var.location
  tags                = local.tags
}

module "diagnostics_kv" {
  source                     = "../../azure-monitor-logging"
  target_resource_id         = module.keyvault.keyvault_id
  log_analytics_workspace_id = module.law.workspace_id
}