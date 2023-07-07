/**
* # azure -keyvault
* 
* CI for KV
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "keyvault" {
  source          = "../../azure-keyvault"
  environment     = var.environment
  application     = "kv"
  location        = var.location
  access_policies = var.access_policies
  secrets         = var.secrets
  tags            = var.tags
}

// test CA integration
module "keyvault_ca" {
  source          = "../../azure-keyvault"
  environment     = var.environment
  application     = "kvca"
  location        = var.location
  ip_rules        = var.ip_rules
  subnet_ids      = var.subnet_ids
  access_policies = var.access_policies
  secrets         = var.secrets
  ca_integration  = true
  provider_name   = "GlobalSign"
  issuer_name     = "GlobalSign"
  tags            = var.tags
}