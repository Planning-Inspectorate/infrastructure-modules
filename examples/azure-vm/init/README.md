Terraform VM Init
=================

## Description

This module produces an init script to be passed to the
`custom_data` parameter of an Azure VM. The module contains  
several built in scripts which can be combined to produce a  
final script. Additional custom commands can also be added.

## Requirements

For Windows the unattend.xml must be configured to run the script  
on first boot. This is configured by default in the  
terraform-vm\_windows module.  
For Linux you must use an image with cloud-init enabled. A list  
of images is [here](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/using-cloud-init).

## Usage

```hcl
module "init_script" {
  source              = "git://bitbucket.org/hiscoxpsg/terraform-vm_init.git"
  init_scripts        = [
    "puppet_agent",
    "disk_format",
    "custom"
  ]
  custom              = "Write-Host some extra commands"
  os_family           = "windows"
  puppet_master       = "puppetmaster.azure.hiscox.com"
  puppet_role         = "server"
  puppet_autosign_key = "key"
}

module "vm" {
  source      = "git://bitbucket.org/hiscoxpsg/terraform-vm_windows.git"
  custom_data = "${module.init_script.rendered}"
}
```

## Included Scripts

### puppet\_agent (Windows/Linux)

Installs Puppet agent. Required variables:

* `puppet_agent_url` (Windows only) - URL to download installer from.
* `proxy_url` (Windows only, optional) - Proxy URL for downloading installer, if using.
* `dns_suffix` - Custom DNS suffix to create the FQDN.
* `puppet_role` - Name of the role to assign to the node.
* `puppet_master` - DNS name of the Puppet master to connect to.
* `puppet_agent_environment` - Name of the puppet agent environment to use.
* `puppet_autosign_key` - Pre-shared key for autosigning the certificate request on the master.

### data\_disk (Windows)

Formats one or more data disks according to the hash passed in to `data_disk`  
Each key should be a drive letter and each value a hash with the following keys

* `label` - file system label.
* `disk_luns` - array of integers starting at 0. If the array count is greater than  
1 the physical disks will be striped using storage spaces.
* `interleave` - set the interleave in KB for striped disks.
* `allocation_unit_size` - sector size in KB.

#### Examples

To format 2 data disks as 2 separate volumes

```hcl
 data_disk = [
  {
     drive_letter         = "e"
     label                = "data"
     disk_luns            = [0]
     interleave           = 65536
     allocation_unit_size = 65536
  },
  {
     drive_letter         = "t"
     label                = "data"
     disk_luns            = [1]
     interleave           = 65536
     allocation_unit_size = 65536
  }
 ]
```

To format 2 striped volumes from 8 physical disks

```hcl
 data_disk = [
  {
     drive_letter         = "e"
     label                = "data"
     disk_luns            = [0,1,2,3]
     interleave           = 65536
     allocation_unit_size = 65536
  },
  {
     drive_letter         = "t"
     label                = "data"
     disk_luns            = [4,5,6,7]
     interleave           = 65536
     allocation_unit_size = 65536
  }
 ]
```

Combination

```hcl
 data_disk = [
  {
     drive_letter         = "e"
     label                = "data"
     disk_luns            = [0,1,2,3]
     interleave           = 65536
     allocation_unit_size = 65536
  },
  {
     drive_letter         = "f"
     label                = "data"
     disk_luns            = [4]
     interleave           = 65536
     allocation_unit_size = 65536
  },
  {
     drive_letter         = "backup"
     label                = "data"
     disk_luns            = [5,6]
     interleave           = 65536
     allocation_unit_size = 65536
  }
 ]
```

### network (Linux)

Configures networking for Linux. Required variables:

* `dns_suffix` - DNS suffix to create the FQDN.
* `proxy_url` (Optional) - URL of the proxy server, if using.

### puppet\_master\_bitbucket (Linux)

Installs Puppet Enterprise and configures it to work with a Bitbucket  
hosted control repo. Required variables:

* `pe_version` - Version of Puppet Enterprise to install.
* `bitbucket_team` - Name of the Bitbucket team hosting the control repo.
* `bitbucket_username` - Bitbucket user to call the REST API.
* `bitbucket_password` - Bitbucket password to call the REST API.
* `control_repo_name` - Name of the control repo to associate with Puppet.
* `pe_console_admin_password` - Administrator password for the Puppet console.
* `pe_console_url` - Hostname for the Puppet console.
* `pe_public_ip` - Public IP or DNS entry for the control repo webhook.
* `pe_webhook_label` - Label for the webhook in Bitbucket.
* `pe_deploy_key_label` - Label for deploy keys in Bitbucket.
* `pe_puppet_role` - Puppet role to assign to the master.

### integration\_runtime (Windows)

Installs and configures the Windows node(s) for a self-hosted integration runtime (SHIR) to connect to an instance of Azure Data factory (ADF). Required variables:

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bitbucket\_password | n/a | `string` | `"bitbucket_password"` | no |
| bitbucket\_team | n/a | `string` | `"bitbucket_team"` | no |
| bitbucket\_username | n/a | `string` | `"bitbucket_username"` | no |
| control\_repo\_name | n/a | `string` | `"control_repo_name"` | no |
| custom | n/a | `string` | `""` | no |
| data\_disk | Example: data\_disk = [<br>      {<br>        drive\_letter         = "e"<br>        label                = "data"<br>        disk\_luns            = [0,1,2,3]<br>        interleave           = 65536<br>        allocation\_unit\_size = 65536<br>      },<br>      {<br>        drive\_letter         = "f"<br>        label                = "logs"<br>        disk\_luns            = [4]<br>        interleave           = null<br>        allocation\_unit\_size = 4096<br>      },<br>      {<br>        drive\_letter         = "t"<br>        label                = "backup"<br>        disk\_luns            = [5,6]<br>        interleave           = 65536<br>        allocation\_unit\_size = 65536<br>    }<br>  ] | `list(object({drive_letter = string, label = string, disk_luns = list(number), interleave = number, allocation_unit_size = number}))` | `[]` | no |
| dns\_suffix | n/a | `string` | `"azure.hiscox.com"` | no |
| init\_scripts | n/a | `list(string)` | `[]` | no |
| os\_family | windows/linux | `string` | n/a | yes |
| pe\_agent\_specified\_environment | n/a | `string` | `"production"` | no |
| pe\_console\_admin\_password | n/a | `string` | `"pe_console_admin_password"` | no |
| pe\_console\_url | n/a | `string` | `"pe_console_url"` | no |
| pe\_deploy\_key\_label | n/a | `string` | `"pe_deploy_key_label"` | no |
| pe\_public\_ip | n/a | `string` | `"pe_public_ip"` | no |
| pe\_puppet\_role | n/a | `string` | `"pe_puppet_role"` | no |
| pe\_version | n/a | `string` | `"pe_version"` | no |
| pe\_webhook\_label | n/a | `string` | `"pe_webhook_label"` | no |
| proxy\_url | n/a | `string` | `"no_proxy"` | no |
| puppet\_agent\_environment | n/a | `string` | `"production"` | no |
| puppet\_agent\_url | n/a | `string` | `"https://downloads.puppetlabs.com/windows/puppet5/puppet-agent-x64-latest.msi"` | no |
| puppet\_autosign\_key | n/a | `string` | `"no_puppet"` | no |
| puppet\_master | n/a | `string` | `"no_puppet"` | no |
| puppet\_role | n/a | `string` | `"no_puppet"` | no |
| shir\_auth\_key | The auth key for a data factory the self-hosted integration runtime should register with | `string` | `""` | no |
| shir\_certificate\_domain | The domain name of the certificate for SHIR | `string` | `""` | no |
| shir\_certificate\_name | The name of the certificate in KeyVault to use for the SHIR | `string` | `""` | no |
| shir\_key\_vault\_name | The name of the KeyVault containing the certificate for the SHIR | `string` | `""` | no |
| shir\_key\_vault\_resource\_group\_name | The name of the resource group of the KeyVault containing the certificate for the SHIR | `string` | `""` | no |
| shir\_secret\_name | The name of the KeyVault secret for the private key of the SHIR certificate | `string` | `""` | no |
| waf\_cluster\_secret | n/a | `string` | `"waf_cluster_secret"` | no |
| waf\_ip\_addresses | n/a | `list(string)` | `[]` | no |
| waf\_license\_keys | n/a | `list(string)` | `[]` | no |
| waf\_oms\_workspace\_id | n/a | `string` | `"waf_oms_workspace_id"` | no |
| waf\_oms\_workspace\_key | n/a | `string` | `"waf_oms_workspace_key"` | no |
| waf\_password | n/a | `string` | `"waf_password"` | no |
| waf\_sku | n/a | `string` | `"waf_sku"` | no |

## Outputs

| Name | Description |
|------|-------------|
| rendered | n/a |

