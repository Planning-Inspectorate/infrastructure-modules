/**
* # azure-subnet
* 
* CI for subnet.
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "subnet" {
  source                   = "../../azure-subnet"
  subnet_name              = var.subnet_name
  vnet_resource_group_name = var.vnet_resource_group_name
  virtual_network_name     = var.virtual_network_name
  address_prefixes         = var.address_prefixes
  service_endpoints        = var.service_endpoints
}
