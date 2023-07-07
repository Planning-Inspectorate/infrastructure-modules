resource "azurerm_kubernetes_cluster" "aks" {
  name                      = "${var.environment}-${var.application}-aks-${var.location}"
  location                  = data.azurerm_resource_group.rg.location
  resource_group_name       = data.azurerm_resource_group.rg.name
  dns_prefix                = "${var.environment}-${var.application}"
  kubernetes_version        = var.kubernetes_version
  private_cluster_enabled   = false
  automatic_channel_upgrade = var.automatic_channel_upgrade
  // see description of variable
  //api_server_authorized_ip_ranges = "${var.api_server_authorized_ip_ranges}"

  linux_profile {
    admin_username = "azureuser"

    ssh_key {
      key_data = var.ssh_pub_key
    }
  }

  node_resource_group = "${var.environment}-${var.application}-aks-node-pools-${var.location}"

  default_node_pool {
    # replace with server identification module?
    name                  = var.environment
    node_count            = var.vm_count
    vm_size               = var.vm_size
    os_disk_size_gb       = var.os_disk_size_gb
    type                  = "VirtualMachineScaleSets"
    availability_zones    = ["1", "2", "3"]
    enable_auto_scaling   = true
    enable_node_public_ip = false
    min_count             = var.node_autoscale_min_count
    max_count             = var.node_autoscale_max_count
    max_pods              = var.max_pods
    tags                  = local.tags

    # always set this - otherwise it'll create its own vnet in the 10.x.x.x/16 range
    # which matches on-prem and peering it would bring about the end of the world
    # and your career
    vnet_subnet_id = var.subnet_id
  }

  identity { // to replace service principal
    type = "SystemAssigned"
  }


  sku_tier = "Free"

  role_based_access_control {
    azure_active_directory {
      managed                = true
      admin_group_object_ids = var.rbac_admin_group_object_ids
    }

    enabled = true
  }

  maintenance_window {
    allowed {
      day   = var.maintenance_allowed.day
      hours = var.maintenance_allowed.hours
    }
  }

  network_profile {
    network_plugin     = "kubenet"
    pod_cidr           = "192.168.0.0/17"
    service_cidr       = "192.168.128.0/17"
    dns_service_ip     = "192.168.128.10"
    docker_bridge_cidr = "172.17.0.1/16"
    load_balancer_sku  = "Standard"
    # load_balancer_profile { //TODO:

    # }
  }

  auto_scaler_profile {
    balance_similar_node_groups      = var.auto_scaler_profile.balance_similar_node_groups
    expander                         = var.auto_scaler_profile.expander
    max_graceful_termination_sec     = var.auto_scaler_profile.max_graceful_termination_sec
    max_node_provisioning_time       = var.auto_scaler_profile.max_node_provisioning_time
    max_unready_nodes                = var.auto_scaler_profile.max_unready_nodes
    max_unready_percentage           = var.auto_scaler_profile.max_unready_percentage
    new_pod_scale_up_delay           = var.auto_scaler_profile.new_pod_scale_up_delay
    scale_down_delay_after_add       = var.auto_scaler_profile.scale_down_delay_after_add
    scale_down_delay_after_delete    = var.auto_scaler_profile.scale_down_delay_after_delete
    scale_down_delay_after_failure   = var.auto_scaler_profile.scale_down_delay_after_failure
    scan_interval                    = var.auto_scaler_profile.scan_interval
    scale_down_unneeded              = var.auto_scaler_profile.scale_down_unneeded
    scale_down_unready               = var.auto_scaler_profile.scale_down_unready
    scale_down_utilization_threshold = var.auto_scaler_profile.scale_down_utilization_threshold
    skip_nodes_with_local_storage    = var.auto_scaler_profile.skip_nodes_with_local_storage
    skip_nodes_with_system_pods      = var.auto_scaler_profile.skip_nodes_with_system_pods
  }

  addon_profile {
    #   azure_policy { // in preview

    #   }

    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.log_analytics_workspace_id
      #   oms_agent_identity { //TODO:?

      #   }
    }
    kube_dashboard {
      enabled = false
    }
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      location // otherwise forces replacement
    ]
  }
}
