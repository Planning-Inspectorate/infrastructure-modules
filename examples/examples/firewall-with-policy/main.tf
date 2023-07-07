/**
* # firewall-with-policy
* 
* An example of deploying a firewall with an attached policy
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

module "fw" {
  source              = "../../azure-firewall"
  resource_group_name = var.vnet_rg
  environment         = var.environment
  application         = var.application
  location            = var.location
  subnet_id           = data.azurerm_subnet.fw.id
  firewall_policy_id  = module.fwp.firewall_policy_id
  tags                = var.tags
  // this is required so that the firewall is destroyed before any part of the policy is destroyed
  depends_on = [
    module.fwp
  ]
}

module "fwp" {
  source              = "../../azure-firewall-policy"
  resource_group_name = var.vnet_rg
  environment         = var.environment
  application         = var.application
  location            = var.location
  application_rules   = var.application_rules
  network_rules       = var.network_rules
  nat_rules           = var.nat_rules
  tags                = var.tags
}
