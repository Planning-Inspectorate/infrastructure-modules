/**
* # azure-application-gateway
*
* CI for Azure Application Gateway.
*
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "gateway" {
  source                = "../../azure-application-gateway"
  environment           = var.environment
  application           = var.application
  location              = var.location
  tags                  = var.tags
  subnet_id             = var.subnet_id
  backend_pool          = var.backend_pool
  http_listeners        = var.http_listeners
  probes                = var.probes
  backend_http_settings = var.backend_http_settings
  request_routing_rules = var.request_routing_rules
}