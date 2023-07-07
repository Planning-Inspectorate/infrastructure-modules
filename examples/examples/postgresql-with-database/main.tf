/**
* # Azure Database for PostgreSQL - Single Server.
* 
* An example provisioning an Azure Database for PostgreSQL - Single Server.
* 
* The example relies heavily upon the defaults in the module:
* 
* * Performance configuration : General Purpose, 2 vCore(s), 5 GB.
* * PostgreSQL version        : 11
* * SSL enforce status        : ENABLED
* * Minimum TLS               : 1.2
* * Backup retention          : 7 days
* * Storage Auto-growth       : Yes
* 
* Database(s) defaults:
* * charset                   : UTF8
* * collation                 : English_United States.1252
*
* Example uses the module auto-generated default local PostgreSQL admin account and password (not stored anywhere other than in tfstate).
* > Azure Active Directory admins are recommended for real world use.
*
* The example PostgreSQL server is built with 'public_network_access_enabled = false' (module default). 
* > A Private Endpoint would be required in order to connect.
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
* AzViz has been used to automatically generate this.
*
* ```pwsh
* Connect-AzAccount
* Set-AzContext -Subscription 'xxxx-xxxx'
* Export-AzViz -ResourceGroup my-resource-group-1, my-rg-2 -Theme light -OutputFormat png -OutputFilePath 'diagrams/design.png' -CategoryDepth 1 -LabelVerbosity 2
* ```
*/

module "postgresql" {
  source              = "../../azure-postgresql"
  environment         = var.environment
  application         = var.application
  location            = var.location
  postgresql_database = var.postgresql_database
  tags                = local.tags
}
