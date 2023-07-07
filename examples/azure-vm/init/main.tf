/**
* Terraform VM Init
* =================
* 
* ## Description
* 
* This module produces an init script to be passed to the
* `custom_data` parameter of an Azure VM. The module contains
* several built in scripts which can be combined to produce a
* final script. Additional custom commands can also be added.
* 
* ## Requirements
* 
* For Windows the unattend.xml must be configured to run the script
* on first boot. This is configured by default in the
* terraform-vm_windows module.
* For Linux you must use an image with cloud-init enabled. A list
* of images is [here](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/using-cloud-init).
* 
* ## Usage
* 
* ```hcl
* module "init_script" {
*   source              = "git://bitbucket.org/hiscoxpsg/terraform-vm_init.git"
*   init_scripts        = [
*     "puppet_agent",
*     "disk_format",
*     "custom"
*   ]
*   custom              = "Write-Host some extra commands"
*   os_family           = "windows"
*   puppet_master       = "puppetmaster.azure.hiscox.com"
*   puppet_role         = "server"
*   puppet_autosign_key = "key"
* }
* 
* module "vm" {
*   source      = "git://bitbucket.org/hiscoxpsg/terraform-vm_windows.git"
*   custom_data = "${module.init_script.rendered}"
* }
* ```
* 
* ## Included Scripts
* 
* ### puppet_agent (Windows/Linux)
* 
* Installs Puppet agent. Required variables:
* 
* * `puppet_agent_url` (Windows only) - URL to download installer from.
* * `proxy_url` (Windows only, optional) - Proxy URL for downloading installer, if using.
* * `dns_suffix` - Custom DNS suffix to create the FQDN.
* * `puppet_role` - Name of the role to assign to the node.
* * `puppet_master` - DNS name of the Puppet master to connect to.
* * `puppet_agent_environment` - Name of the puppet agent environment to use.
* * `puppet_autosign_key` - Pre-shared key for autosigning the certificate request on the master.
* 
* ### data_disk (Windows)
* 
* Formats one or more data disks according to the hash passed in to `data_disk`
* Each key should be a drive letter and each value a hash with the following keys
* 
* * `label` - file system label.
* * `disk_luns` - array of integers starting at 0. If the array count is greater than
* 1 the physical disks will be striped using storage spaces.
* * `interleave` - set the interleave in KB for striped disks.
* * `allocation_unit_size` - sector size in KB.
* 
* #### Examples
* 
* To format 2 data disks as 2 separate volumes
* 
* ```hcl
*  data_disk = [
*   {
*      drive_letter         = "e"
*      label                = "data"
*      disk_luns            = [0]
*      interleave           = 65536
*      allocation_unit_size = 65536
*   },
*   {
*      drive_letter         = "t"
*      label                = "data"
*      disk_luns            = [1]
*      interleave           = 65536
*      allocation_unit_size = 65536
*   }
*  ]
* ```
* 
* To format 2 striped volumes from 8 physical disks
* 
* ```hcl
*  data_disk = [
*   {
*      drive_letter         = "e"
*      label                = "data"
*      disk_luns            = [0,1,2,3]
*      interleave           = 65536
*      allocation_unit_size = 65536
*   },
*   {
*      drive_letter         = "t"
*      label                = "data"
*      disk_luns            = [4,5,6,7]
*      interleave           = 65536
*      allocation_unit_size = 65536
*   }
*  ]
* ```
* 
* Combination
* 
* ```hcl
*  data_disk = [
*   {
*      drive_letter         = "e"
*      label                = "data"
*      disk_luns            = [0,1,2,3]
*      interleave           = 65536
*      allocation_unit_size = 65536
*   },
*   {
*      drive_letter         = "f"
*      label                = "data"
*      disk_luns            = [4]
*      interleave           = 65536
*      allocation_unit_size = 65536
*   },
*   {
*      drive_letter         = "backup"
*      label                = "data"
*      disk_luns            = [5,6]
*      interleave           = 65536
*      allocation_unit_size = 65536
*   }
*  ]
* ```
* 
* ### network (Linux)
* 
* Configures networking for Linux. Required variables:
* 
* * `dns_suffix` - DNS suffix to create the FQDN.
* * `proxy_url` (Optional) - URL of the proxy server, if using.
* 
* ### puppet_master_bitbucket (Linux)
* 
* Installs Puppet Enterprise and configures it to work with a Bitbucket
* hosted control repo. Required variables:
* 
* * `pe_version` - Version of Puppet Enterprise to install.
* * `bitbucket_team` - Name of the Bitbucket team hosting the control repo.
* * `bitbucket_username` - Bitbucket user to call the REST API.
* * `bitbucket_password` - Bitbucket password to call the REST API.
* * `control_repo_name` - Name of the control repo to associate with Puppet.
* * `pe_console_admin_password` - Administrator password for the Puppet console.
* * `pe_console_url` - Hostname for the Puppet console.
* * `pe_public_ip` - Public IP or DNS entry for the control repo webhook.
* * `pe_webhook_label` - Label for the webhook in Bitbucket.
* * `pe_deploy_key_label` - Label for deploy keys in Bitbucket.
* * `pe_puppet_role` - Puppet role to assign to the master.
* 
* ### integration_runtime (Windows)
*
* Installs and configures the Windows node(s) for a self-hosted integration runtime (SHIR) to connect to an instance of Azure Data factory (ADF). Required variables:

* * `shir_auth_key` - Authorisation key to connect to the specified instance of ADF.
* * `shir_key_vault_name` - The Azure Key Vault instance containing the certificate for this SHIR.
* * `shir_certificate_name` - The name of the certificate object in Azure Key Vault.
* * `shir_secret_name` - The name of the secret object in Azure Key Vault containing the password for the private key for the above certificate.
* * `shir_certificate_domain` - The domain name/subject for the above certificate.
*
* ### custom (Windows/Linux)
* 
* Additional custom commands to run. Required variables:
* 
* * `custom` - String containing the commands to run.
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/
