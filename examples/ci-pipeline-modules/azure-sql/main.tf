/**
* # azure-sql
* 
* CI for PaaS SQL
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

module "standalone" {
  source           = "../../azure-sql"
  environment      = var.environment
  application      = "standalone"
  location         = var.location
  allow_subnet_ids = var.allow_subnet_ids
  standalone_dbs = {
    staging = {
      max_size_gb = 50
      collation   = "Latin1_General_CS_AI"
      sku_name    = "P1"
    },
    sample = {
      max_size_gb = 50
      collation   = "Latin1_General_CS_AI"
      sku_name    = "S0"
    },
  }
  tags                            = var.tags
}

module "pool" {
  source           = "../../azure-sql"
  environment      = var.environment
  application      = "pool"
  location         = var.location
  allow_subnet_ids = var.allow_subnet_ids
  elastic_pool_sku = {
    name     = "BC_Gen5"
    tier     = "BusinessCritical"
    family   = "Gen5"
    capacity = 4
  }
  pool_dbs = {
    staging = {
      max_size_gb = 64
    },
    sample = {
      max_size_gb = 32
    },
  }
  tags                            = var.tags
}
