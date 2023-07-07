/**
* # azure-redis
* 
* This directory stands up a Redis cache instance.
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "redis" {
  source               = "../../azure-redis"
  environment          = var.environment
  application          = var.application
  location             = var.location
  sku_name             = var.sku_name
  capacity             = var.capacity
  redis_firewall_rules = var.redis_firewall_rules
  tags                 = var.tags
}
