/**
* # azure-storage-account
*
* CI for Storage Account
*
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// these test various different flavours of the storage account module

// standalone
module "storage" {
  source      = "../../azure-storage-account"
  environment = var.environment
  application = "standalone"
  location    = var.location
  tags        = var.tags
}
// standalone with network rules
module "storagenetwork" {
  source           = "../../azure-storage-account"
  environment      = var.environment
  application      = "storagenetwork"
  location         = var.location
  network_rule_ips = ["127.0.0.1"]
  tags             = var.tags
}
// table
module "table" {
  source                 = "../../azure-storage-account"
  environment            = var.environment
  application            = "table"
  location               = var.location
  network_default_action = "Allow" //this allows local execution - without it 403'ed reading remote state
  tables                 = ["tableFirst", "tableSecond"]
  tags                   = var.tags
}
// share
module "share" {
  source                 = "../../azure-storage-account"
  environment            = var.environment
  application            = "share"
  location               = var.location
  network_default_action = "Allow" //this allows local execution - without it 403'ed reading remote state
  shares = [
    {
      name  = "exampleshare"
      quota = "101"
    }
  ]
  share_directories = {
    dirOne = "exampleshare"
    dirTwo = "exampleshare"
  }
  tags = var.tags
}
// queue
module "queue" {
  source                 = "../../azure-storage-account"
  environment            = var.environment
  application            = "queue"
  location               = var.location
  network_default_action = "Allow" //this allows local execution - without it 403'ed reading remote state
  queue_name             = ["imaqueuehello"]
  tags                   = var.tags
}
// blob
module "blob" {
  source                 = "../../azure-storage-account"
  environment            = var.environment
  application            = "blob"
  location               = var.location
  network_default_action = "Allow" //this allows local execution - without it 403'ed reading remote state
  container_name         = ["first-container"]
  blobs = [
    {
      name           = "exampleblob"
      container_name = "first-container"
      type           = "Block"
      size           = "512"
    }
  ]
  tags = var.tags
}