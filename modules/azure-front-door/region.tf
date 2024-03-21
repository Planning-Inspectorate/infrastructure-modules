module "azure_region_uks" {
  #checkov:skip=CKV_TF_1: Use of commit hash is not required for this module
  source  = "claranet/regions/azurerm"
  version = "5.1.0"

  azure_region = var.location
}
