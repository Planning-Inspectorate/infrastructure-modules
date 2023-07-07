/**
* # azure-redis
* 
* This directory stands up a Redis cache instance.
* 
* ## How To Use
* 
* Include example code snippets:
*
* ### Example One
*
* ```terraform
* module "redis" {
*   source      = "git@ssh.dev.azure.com:v3/hiscox/gp-psg/terraform-modules//azure-redis"
*   environment = "dev"
*   application = "app"
*   location    = "northeurope"
*   sku_name    = "Standard"
*   capacity    = 2
* }
* ```
* 
* ## How To Update this README.md
* 
* * terraform-docs has been used to automatically generate this readme based on comments, variables.tf and output.tf.
* * Follow the setup instructions here: https://github.com/segmentio/terraform-docs
* * Write your terraform-docs to a file like so: `terraform-docs md . | Out-File README.md`
*/

// if you do not specify an existing resurce group one will be created for you,
// when supplying the resource group name to a resource declaration you should use
// the data type i.e 'data.azurerm_resource_group.rg.name'
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "${var.environment}-${var.application}-redis-${var.location}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_redis_cache" "redis" {
  name                = "${var.environment}-${var.application}-rediscache-${var.location}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  capacity            = var.capacity
  family              = var.family[var.sku_name]
  sku_name            = var.sku_name
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  redis_configuration {
  }
}

resource "azurerm_redis_firewall_rule" "rule" {
  for_each            = var.redis_firewall_rules
  name                = each.key
  redis_cache_name    = azurerm_redis_cache.redis.name
  resource_group_name = data.azurerm_resource_group.rg.name
  start_ip            = each.value.start_ip
  end_ip              = each.value.end_ip
}

