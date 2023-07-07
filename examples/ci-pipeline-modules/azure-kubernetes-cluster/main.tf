/**
* # azure-kubernetes-cluster
*
* CI for Azure Kubernetes Service (AKS) cluster.
* 
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`. Alternatively setup a pre-cmmit hook to always ensure your README.md is up to date
*/

module "aks" {
  source                     = "../../azure-kubernetes-cluster"
  environment                = var.environment
  application                = var.application
  location                   = var.location
  ssh_pub_key                = var.ssh_pub_key
  log_analytics_workspace_id = module.law.workspace_id
  keyvault_id                = module.keyvault.keyvault_id
  subnet_id                  = module.subnet.subnet_id
  tags                       = var.tags
}
