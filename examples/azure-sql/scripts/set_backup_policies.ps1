<#
    This script will only work in conjuction with Hiscox PS Deploy tools script as it depends on the envrionmental variables
    set by the same to login using Azure Powershell.
#>

# Loading environmental variables created and used to login by PSDeploy tools scripts
$arm_client_secret  = (Get-ChildItem Env:ARM_CLIENT_SECRET).value | ConvertTo-SecureString -AsPlainText -Force
$arm_client_id      = (Get-ChildItem Env:ARM_CLIENT_ID).value
$arm_tenant_id      = (Get-ChildItem Env:ARM_TENANT_ID).value

# Spliting received string into an array
$database_list = "${database_names}" -split ','

# Creating PS Credentials object and using the same to login
$pscredential = New-Object System.Management.Automation.PSCredential( $arm_client_id, $arm_client_secret)
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $arm_tenant_id

Start-Sleep -Seconds 60
foreach ($database in $database_list) {
    # Set short backup retention policy
    Set-AzSqlDatabaseBackupShortTermRetentionPolicy -ResourceGroup ${resource_group} -ServerName ${server_name} -DataBase $database -RetentionDays ${retention_days}
    # Set Long term backup retention policy
    # FK-325 - Long term backup policy should be deployed only for prod and preprod environments
    if (${is_db_bck_longterm_retention_required} -eq 1){
        Set-AzSqlDatabaseBackupLongTermRetentionPolicy -ResourceGroupName ${resource_group} -ServerName ${server_name} -DatabaseName $database -WeeklyRetention "P1M" -MonthlyRetention "P10Y"
    } else {
        Set-AzSqlDatabaseBackupLongTermRetentionPolicy -ResourceGroupName ${resource_group} -ServerName ${server_name} -DatabaseName $database -WeeklyRetention 0 -MonthlyRetention 0
    }
}

Disconnect-AzAccount