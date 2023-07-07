environment   = "ci"
application   = "redistest"
location      = "northeurope"
sku_name      = "Standard"
capacity = 2

//can contain only alphanumeric characters
redis_firewall_rules = {
  name = {
    start_ip = "172.29.32.0"
    end_ip = "172.29.32.21"
  }
}