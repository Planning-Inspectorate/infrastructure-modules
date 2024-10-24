module "azure_region_uks" {
  #checkov:skip=CKV_TF_1: Use of commit hash is not required for this module
  source  = "claranet/regions/azurerm"
  version = "7.2.1"

  azure_region = var.location
}
