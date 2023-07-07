/**
* # azure-service-bus
* 
* CI for Service Bus instance.
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "sb" {
  source      = "../../azure-service-bus"
  environment = var.environment
  application = var.application
  location    = var.location
  sku         = var.sku
  queues = [
    {
      name          = "example1"
      lock_duration = "PT5M"
    },
    {
      name               = "example2"
      max_delivery_count = 3
    }
  ]
  tags = var.tags
}