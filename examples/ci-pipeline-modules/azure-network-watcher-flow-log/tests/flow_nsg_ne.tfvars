/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

application = "testnsgflow"

location = "northeurope"

nsg_in_rules = {
}
nsg_out_rules = {
}

network_watcher_name                = "NetworkWatcher_northeurope"

network_watcher_resource_group_name = "NetworkWatcherRG"