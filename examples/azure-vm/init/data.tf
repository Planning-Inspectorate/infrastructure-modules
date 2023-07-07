data "template_file" "init" {
  count = length(var.init_scripts)
  template = file(
    "${path.module}/${var.os_family}/${element(var.init_scripts, count.index)}.tpl",
  )

  vars = {
    proxy_url                      = var.proxy_url
    dns_suffix                     = var.dns_suffix
    puppet_agent_url               = var.puppet_agent_url
    puppet_role                    = var.puppet_role
    puppet_master                  = var.puppet_master
    puppet_agent_environment       = var.puppet_agent_environment
    puppet_autosign_key            = var.puppet_autosign_key
    waf_ip_addresses               = jsonencode(var.waf_ip_addresses)
    waf_license_keys               = jsonencode(var.waf_license_keys)
    waf_sku                        = var.waf_sku
    waf_password                   = var.waf_password
    waf_cluster_secret             = var.waf_cluster_secret
    waf_oms_workspace_id           = var.waf_oms_workspace_id
    waf_oms_workspace_key          = var.waf_oms_workspace_key
    data_disk                      = jsonencode(var.data_disk)
    pe_version                     = var.pe_version
    bitbucket_team                 = var.bitbucket_team
    bitbucket_username             = var.bitbucket_username
    bitbucket_password             = var.bitbucket_password
    control_repo_name              = var.control_repo_name
    pe_console_admin_password      = var.pe_console_admin_password
    pe_console_url                 = var.pe_console_url
    pe_public_ip                   = var.pe_public_ip
    pe_webhook_label               = var.pe_webhook_label
    pe_deploy_key_label            = var.pe_deploy_key_label
    pe_puppet_role                 = var.pe_puppet_role
    pe_agent_specified_environment = var.pe_agent_specified_environment
    pe_eyaml_private_key           = var.pe_eyaml_private_key
    pe_eyaml_public_key            = var.pe_eyaml_public_key
    pe_puppetmaster_replica        = var.pe_puppetmaster_replica
    shir_auth_key                  = var.shir_auth_key
    shir_certificate_domain        = var.shir_certificate_domain
    shir_certificate_name          = var.shir_certificate_name
    shir_secret_name               = var.shir_secret_name
    shir_key_vault_name            = var.shir_key_vault_name
    shir_key_vault_resource_group_name = var.shir_key_vault_resource_group_name
    custom                         = var.custom
  }
}

