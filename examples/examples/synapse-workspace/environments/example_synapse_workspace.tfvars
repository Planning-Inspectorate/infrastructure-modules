/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

application = "exsynapse"

location = "northeurope"

synapse_dlg2fs_name = "exsynapsedlg2fs"

aad_admin_user = "svc_ci_exsql_tfsql@hiscox.com"

sqlpools = [
  {
    name           = "synapsepool"
    pool_sku_name  = "DW100c"
  }
]

dlg2fs = ["dlg2fs1", "dlg2fs2"]
