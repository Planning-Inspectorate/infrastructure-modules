/**
* # azure-storage-account
*
* Creates an Azure Storage Account and optionally different modes of storage. By default all private and public access if forbidden as well access from Azure Services. To permit access you need ot supply a list of public IPs and/or a list of subnet IDs.
*
* As Storage Account names must be globally unique we default to generating a random string for the name - as everything should be driven through automation the name is not generally important. If however you need a very specific name for a Storage Account you can override the auto generated name through the variable `storage_name`.
*
* Soft delete will be auto enabled on any storage accounts created in production environments and can be explicitly set for other environments using the 'soft_delete_retention_policy' bool. The retention period set for both the container and blobs is 90 days.
*
* NB: if you create storage with blobs/shares/tables/queues without any specific network rules Terraform will be 403'ed when attempting to apply/destroy future changes as it's unable to read the remote state of the resource(s)
*
* ## How To Use
*
* Outputs should be used as inputs in a parent module
*
* ### Standalone Storage Account
*
* ```terraform
* module "storage" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
* }
* ```
*
* ### Standalone Storage Account which allows network access
*
* ```terraform
* module "storage" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   network_rule_ips = ["127.0.0.1"]
* }
* ```
*
* ### Blob storage
*
* ```terraform
* module "storage" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   container_name = ["first-container"]
*   blobs = [
*     {
*       name = "exampleblob"
*       container_name = "first-container"
*       type = "Block"
*       size = "512"
*     }
*   ]
* }
* ```
*
* ### Queue Storage
*
* ```terraform
* module "storage" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   queue_name = ["firstqueue", "secondqueue"]
* }
* ```
*
* ### Share Storage
*
* ```terraform
* module "storage" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   shares = [
*     {
*       name = "exampleshare"
*       quota = "101"
*     }
*   ]
*
*   NOTE - At present share directories only support creation at the root of the share. A directory with a parent of another directory is not supported. Directory structures should be created post Storage Account creation.
*   share_directories = {
*     dirOne = "exampleshare"
*     dirTwo = "exampleshare"
*   }
* }
* ```
*
* ### Table Storage
*
* ```terraform
* module "storage" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-storage-account"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   tables      = ["tableOne", "tableTwo"]
* }
* ```
*
* ## How To Update this README.md
*
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// if you do not specify an existing resurce group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "${var.environment}-${var.application}-storage-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "random_string" "storage_name" {
  length  = 24
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage" {
  name                      = var.storage_name == "" ? random_string.storage_name.result : var.storage_name
  resource_group_name       = data.azurerm_resource_group.rg.name
  location                  = var.location
  account_tier              = var.storage_tier
  account_replication_type  = var.storage_replication
  account_kind              = var.account_kind
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  access_tier               = var.access_tier
  is_hns_enabled            = var.is_hns_enabled
  allow_blob_public_access  = false
  large_file_share_enabled  = var.large_file_share_enabled

  dynamic "custom_domain" {
    for_each = var.custom_domain
    content {
      name          = custom_domain.value["name"]
      use_subdomain = custom_domain.value["use_subdomain"]
    }
  }

  identity {
    type = "SystemAssigned"
  }

  dynamic "blob_properties" {
    for_each = local.soft_delete_retention_policy == true ? toset([1]) : toset([])
    
    content {
      delete_retention_policy {
        days = 90
      }
      container_delete_retention_policy {
        days = 90
      }
    }
  }

  dynamic "azure_files_authentication" {
    for_each = var.directory_type == "ad-joined" ? ["1"] : []
    content {
      directory_type = "AD"
      active_directory {
        domain_name         = "hiscox.com"
        domain_sid          = "S-1-5-21-2141217978-1466855917-176895030"
        domain_guid         = "b9bfb2a8-ab2f-43bc-b2c2-8dbaf56fc3c8"
        forest_name         = "root.local"
        netbios_domain_name = "hiscox.com"
        storage_sid         = var.storage_sid
      }
    }
  }

  # blob_properties {
  #   cors_rule {
  #     allowed_headers
  #     allowed_methods
  #     allowed_origins
  #     exposed_headers
  #     max_age_in_seconds
  #   }

  #   delete_retention_policy {
  #     days = 7
  #   }

  # }

  # queue_properties {
  #   cors_rule {
  #     allowed_headers
  #     allowed_methods
  #     allowed_origins
  #     exposed_headers
  #     max_age_in_seconds
  #   }
  #   logging {
  #     delete
  #     read
  #     version
  #     write
  #     retention_policy_days
  #   }
  #   minute_metrics {
  #     enabled
  #     version
  #     include_apis
  #     retention_policy_days
  #   }
  #   hour_metrics {
  #     enabled
  #     version
  #     include_apis
  #     retention_policy_days
  #   }
  # }

  dynamic "static_website" {
    for_each = var.static_website
    content {
      index_document     = static_website.value.index_document
      error_404_document = static_website.value.error_404_document
    }
  }

  tags = local.tags
}

resource "azurerm_storage_account_network_rules" "storage-network-rule" {
  storage_account_id         = azurerm_storage_account.storage.id
  default_action             = var.network_default_action
  ip_rules                   = var.network_rule_ips
  virtual_network_subnet_ids = var.network_rule_virtual_network_subnet_ids_include_cicd_agents ? concat(local.cicd_subnet_ids, var.network_rule_virtual_network_subnet_ids) : var.network_rule_virtual_network_subnet_ids
  bypass                     = var.network_rule_bypass
}

resource "azurerm_storage_container" "container" {
  for_each              = toset(var.container_name)
  name                  = each.key
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = var.container_access_type //TODO: this needs to be a list
}

resource "azurerm_storage_blob" "blob" {
  count                  = length(var.blobs)
  name                   = var.blobs[count.index].name
  storage_container_name = var.blobs[count.index].container_name
  storage_account_name   = azurerm_storage_account.storage.name
  type                   = var.blobs[count.index].type
  size                   = contains(keys(var.blobs[count.index]), "size") ? var.blobs[count.index].size : 0
  source                 = contains(keys(var.blobs[count.index]), "source") ? var.blobs[count.index].source : null
  #content_md5 only valid for block with source provided. Will update if source content md5 changes
  content_md5 = contains(keys(var.blobs[count.index]), "source") && var.blobs[count.index].type == "Block" ? filemd5(var.blobs[count.index].source) : null
  depends_on  = [azurerm_storage_container.container]
}

resource "azurerm_storage_queue" "queue" {
  for_each             = toset(var.queue_name)
  name                 = each.key
  storage_account_name = azurerm_storage_account.storage.name
}

resource "azurerm_storage_share" "share" {
  count                = length(var.shares)
  name                 = var.shares[count.index].name
  storage_account_name = azurerm_storage_account.storage.name
  quota                = var.shares[count.index].quota

  // make dynamic - !! WARNING: requires extra steps, see Microsoft docs re: enabling AD DS
  # acl {
  #   id = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"

  #   access_policy {
  #     permissions = "rwdl"
  #     start       = "2019-07-02T09:38:21.0000000Z"
  #     expiry      = "2019-07-02T10:38:21.0000000Z"
  #   }
  # }
}

resource "azurerm_storage_share_directory" "share_directories" {
  for_each             = var.share_directories
  name                 = each.key
  share_name           = each.value
  storage_account_name = azurerm_storage_account.storage.name
  depends_on           = [azurerm_storage_share.share]
}

resource "azurerm_storage_table" "table" {
  for_each             = toset(var.tables)
  name                 = each.key
  storage_account_name = azurerm_storage_account.storage.name

  //acl !! WARNING: requires extra steps, see Microsoft docs re: enabling AD DS
}

resource "azurerm_storage_data_lake_gen2_filesystem" "storage_dlg2fs" {
  for_each           = toset(var.dlg2fs)
  name               = each.key
  storage_account_id = azurerm_storage_account.storage.id
}

# resource "azurerm_storage_table_entity" "table_entity" {
#   for_each = var.tables
#   storage_account_name = azurerm_storage_account.storage.name
#   table_name           = each.key

#   partition_key = each.value.partition_key
#   row_key       = each.value.row_key

#   entity = {
#     example = "example"
#   }
# }