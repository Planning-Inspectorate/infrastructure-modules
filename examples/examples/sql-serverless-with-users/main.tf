/**
* # sql-serverless-with-users
* 
* Example provisioning a PaaS SQL instance with 2 serverless databases. Example also demonstrates creating contained users via Terraform
* 
* ## How To Update this README.md
*
* terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
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
  name     = "${var.environment}-${var.application}-serverless-${var.location}"
  location = var.location
  tags     = local.tags
}

module "sql_serverless" {
  source              = "../../azure-sql"
  environment         = var.environment
  application         = var.application
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allow_subnet_ids    = var.allow_subnet_ids
  standalone_dbs      = var.standalone_dbs
  database_users      = var.database_users
}