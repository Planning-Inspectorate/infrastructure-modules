locals {
  environment = {
    prod           = "pr"
    production     = "pr"
    livesupport    = "ls"
    training       = "tr"
    sharedservices = "ss"
    dev            = "dv"
    devtest        = "dv"
    systest        = "sy"
    uat            = "ut"
    staging        = "st"
    poc            = "pc"
    build          = "ci"
    ci             = "ci"
    performance    = "pe"
  }

  business = {
    it_services   = "01"
    us            = "02"
    uk            = "03"
    europe        = "04"
    london_market = "05"
    group         = "06"
    hiscox_re     = "07"
  }

  service = {
    infrastructure = "01"
    app            = "02"
    database       = "03"
    web            = "04"
    workstation    = "05"
    head_node      = "06"
    analysis       = "07"
    cluster_name   = "08"
    MSDTC          = "09"
    AG_listener    = "10"
    IIS_AP         = "11"
    fabric_AP      = "12"
    file_server    = "13"
  }
}

locals {
  chosen_environment = local.environment[var.environment]
  chosen_business    = local.business[var.business]
  chosen_service     = local.service[var.service]
  prefix             = "${local.chosen_environment}${local.chosen_business}${local.chosen_service}"
  name               = "${local.prefix}${random_string.random_name.result}"
}

