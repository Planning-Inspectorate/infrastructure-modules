/**
*
* Configures the sql server firewall
*
*/

# # # #
# North Europe SQL Firewall rules
# # # #
resource "azurerm_sql_firewall_rule" "sql_firewall_mspeering_tc1" {
  name                = "allow-microsoft-peering-tc1"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_mssql_server.sql_server.name
  start_ip_address    = "109.71.86.32"
  end_ip_address      = "109.71.86.63"
}

resource "azurerm_sql_firewall_rule" "sql_firewall_mspeering_tc2" {
  name                = "allow-microsoft-peering-tc2"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_mssql_server.sql_server.name
  start_ip_address    = "109.71.86.64"
  end_ip_address      = "109.71.86.95"
}

// setting the IP range to 0.0.0.0 toggles 'Allow access to Azure services' to TRUE. This is covered in the Azure API docs
resource "azurerm_sql_firewall_rule" "sql_firewall_azure" {
  name                = "AllowAccessAzureServices"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_mssql_server.sql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Create azure sql server network firewall rules
resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  for_each = merge(var.allow_subnet_ids, { for i, v in local.cicd_subnet_ids_in_this_region : "sql-vnet-cicd-rule-${i + 1}" => v }) # cicd subnets from this region + any passed in specifically
  # The list of cicd subnets is converted to a map (to allow it to be merged with allow_subnet_ids, which is itself a map)
  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_mssql_server.sql_server.name
  subnet_id           = each.value
}