/**
* # keyvault -access-policies
* 
* This will set access policies for a keyvault
* 
* ## How To Use
* 
* * Inputs can be refereced in a module to create your cluster of the sort: `module "keyvault" {...}`
*
* ## Example
* 
* ```
* data "azurerm_key_vault" "devkv" {
*  name      = "dev-app-kv-ne"
*  resource_group_name = "dev-app-kv-northeurope"
* }
*
* module "keyvault_access_policies" {
*   source       = "git://bitbucket.org/hiscoxpsg/terraform-keyvault.git?ref=0.4-latest//access_policies"
*   keyvault_id  = data.azurerm_key_vault.devkv.id
*   read_users   = ["a.secretreader", "another.secretreader"]
*   write_user   = ["secret.writer"]
*   admin_user   = ["super.user"]
*   read_ids     = ["99999999-aaaa-1111-2222-3333ffffffff"]
*   write_ids    = ["11111111-bbbb-dddd-eeee-ffffffffffff", "333333333-ffff-6666-7777-aaaaffffaaaa"]
* }
* ```
*
* It will assign read access rights to two named users and write access to another.
* It will assign admin rights to 'super.user'
* It will assign read access to a principal with id '999...' and write access to two two other principals
*
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: [terraform-docs](https://github.com/segmentio/terraform-docs)
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

data "azurerm_client_config" "current" {}

data "azuread_service_principal" "admin_sp" {
  count        = length(var.admin_users)
  display_name = var.admin_users[count.index]
}

resource "azurerm_key_vault_access_policy" "admin" {
  count                   = length(var.admin_users)
  key_vault_id            = var.keyvault_id
  tenant_id               = local.tenant_id
  object_id               = data.azuread_service_principal.admin_sp.*.object_id[count.index]
  certificate_permissions = local.admin_certificate_permissions
  key_permissions         = local.admin_key_permissions
  secret_permissions      = local.admin_secret_permissions
}

resource "azurerm_key_vault_access_policy" "admin_ids" {
  count                   = length(var.admin_ids)
  key_vault_id            = var.keyvault_id
  tenant_id               = local.tenant_id
  object_id               = var.admin_ids[count.index]
  certificate_permissions = local.admin_certificate_permissions
  key_permissions         = local.admin_key_permissions
  secret_permissions      = local.admin_secret_permissions
}

data "azuread_service_principal" "write_sp" {
  count        = length(var.write_users)
  display_name = var.write_users[count.index]
}

resource "azurerm_key_vault_access_policy" "write" {
  count                   = length(var.write_users)
  key_vault_id            = var.keyvault_id
  tenant_id               = local.tenant_id
  object_id               = data.azuread_service_principal.write_sp.*.object_id[count.index]
  certificate_permissions = local.write_certificate_permissions
  key_permissions         = local.write_key_permissions
  secret_permissions      = local.write_secret_permissions
}

resource "azurerm_key_vault_access_policy" "write_ids" {
  count                   = length(var.write_ids)
  key_vault_id            = var.keyvault_id
  tenant_id               = local.tenant_id
  object_id               = var.write_ids[count.index]
  certificate_permissions = local.write_certificate_permissions
  key_permissions         = local.write_key_permissions
  secret_permissions      = local.write_secret_permissions
}

data "azuread_service_principal" "read_sp" {
  count        = length(var.read_users)
  display_name = var.read_users[count.index]
}

resource "azurerm_key_vault_access_policy" "read" {
  count                   = length(var.read_users)
  key_vault_id            = var.keyvault_id
  tenant_id               = local.tenant_id
  object_id               = data.azuread_service_principal.read_sp.*.object_id[count.index]
  certificate_permissions = local.read_certificate_permissions
  key_permissions         = local.read_key_permissions
  secret_permissions      = local.read_secret_permissions
}

resource "azurerm_key_vault_access_policy" "read_ids" {
  count                   = length(var.read_ids)
  key_vault_id            = var.keyvault_id
  tenant_id               = local.tenant_id
  object_id               = var.read_ids[count.index]
  certificate_permissions = local.read_certificate_permissions
  key_permissions         = local.read_key_permissions
  secret_permissions      = local.read_secret_permissions
}
