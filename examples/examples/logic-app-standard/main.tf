/**
* # logic-app-standard
* 
* An exmaple of deploying a Logic App Standard that uses Swift integration to restrict outbound traffic flow alongside Application Inisghts integration.
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

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.environment}-${var.application}-test-${var.location}"
  location = var.location
  tags     = local.tags
}

// nsg to managed logic app outbound connectivity
module "nsg_outbound" {
  source              = "../../azure-network-security-group"
  resource_group_name = azurerm_resource_group.resource_group.name
  environment         = var.environment
  application         = "${var.application}-outbound"
  location            = var.location
  tags                = local.tags
  nsg_in_rules        = local.nsg_in_rules_outbound
  nsg_out_rules       = local.nsg_out_rules_outbound
}

// we use a dedicated subnet for restricting outbound connectivity to a private network
module "subnet_outbound" {
  source                    = "../../azure-subnet"
  subnet_name               = join("-", [var.environment, var.application, "outbound"])
  vnet_resource_group_name  = var.vnet_resource_group_name
  virtual_network_name      = var.virtual_network_name
  address_prefixes          = var.address_prefixes_outbound
  network_security_group_id = [module.nsg_outbound.network_security_group_id]
  service_endpoints         = ["Microsoft.Storage", "Microsoft.Web", "Microsoft.KeyVault"]
  delegation = [
    {
      name                       = join("-", [var.environment, var.application, "delegation"])
      service_delegation_name    = "Microsoft.Web/serverFarms"
      service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  ]
}

module "storage" {
  source                                  = "../../azure-storage-account"
  environment                             = var.environment
  application                             = var.application
  location                                = var.location
  resource_group_name                     = azurerm_resource_group.resource_group.name
  network_default_action                  = "Allow" // don't set this for real, this just makes local testing simple
  network_rule_virtual_network_subnet_ids = [module.subnet_outbound.subnet_id]
  tags                                    = local.tags
}

module "ai" {
  source              = "../../azure-application-insights"
  environment         = var.environment
  application         = var.application
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  application_type    = "Node.JS"
  workspace_id        = data.azurerm_log_analytics_workspace.law.id
  tags                = local.tags
}

module "asp" {
  source               = "../../azure-app-service-plan"
  environment          = var.environment
  application          = var.application
  location             = var.location
  resource_group_name  = azurerm_resource_group.resource_group.name
  kind                 = "elastic"
  reserved             = false
  elastic_worker_count = 20
  sku = {
    tier     = "WorkflowStandard"
    size     = "WS1"
    capacity = "1"
  }
  tags = local.tags
}

module "las" {
  source                     = "../../azure-logic-app-standard"
  environment                = var.environment
  application                = var.application
  resource_group_name        = azurerm_resource_group.resource_group.name
  location                   = var.location
  app_service_plan_id        = module.asp.id
  storage_account_name       = module.storage.storage_name
  storage_account_access_key = module.storage.primary_access_key
  site_config = {
    ip_restrictions = {
      ip_addresses = [
        {
          name       = "Deny-all"
          ip_address = "Any"
          priority   = 2147483647
          action     = "Deny"
        }
      ]
      service_tags = [
        {
          name             = "allow-azure-monitor"
          service_tag_name = "AzureMonitor"
          priority         = 250
          action           = "Allow"
        },
        {
          name             = "allow-app-insights"
          service_tag_name = "ApplicationInsightsAvailability"
          priority         = 240
          action           = "Allow"
        },
        {
          name             = "allow-storage"
          service_tag_name = "Storage"
          priority         = 150
          action           = "Allow"
        }
      ]
      subnet_ids = [
        {
          subnet_id = module.subnet_outbound.subnet_id
          name      = "allow-outbound-subnet"
          priority  = 260
          action    = "Allow"
        }
      ]
    }
  }
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"              = "node"
    "WEBSITE_NODE_DEFAULT_VERSION"          = "~12"
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = module.ai.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = module.ai.connection_string
    "WEBSITE_VNET_ROUTE_ALL"                = "1"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_out" {
  app_service_id = module.las.id
  subnet_id      = module.subnet_outbound.subnet_id
}