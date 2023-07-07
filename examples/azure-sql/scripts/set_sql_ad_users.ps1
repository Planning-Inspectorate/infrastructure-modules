# Loading environmental variables created and used to login by PSDeploy tools scripts
$arm_client_secret  = (Get-ChildItem Env:ARM_CLIENT_SECRET).value | ConvertTo-SecureString -AsPlainText -Force
$arm_client_id      = (Get-ChildItem Env:ARM_CLIENT_ID).value
$arm_tenant_id      = (Get-ChildItem Env:ARM_TENANT_ID).value

# Creating PS Credentials object and using the same to login
$pscredential = New-Object System.Management.Automation.PSCredential( $arm_client_id, $arm_client_secret)
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $arm_tenant_id

# Spliting received string into an array
$database_list = "${database_names}" -split ','

# Adding the required groups to the default Master database
$queries = @(
  ("-d 'master' -Q `"IF NOT EXISTS(SELECT name FROM sys.sysusers WHERE name = '${environment}_${application}_db_owner_mi') BEGIN; CREATE USER [${environment}_${application}_db_owner_mi] FROM EXTERNAL PROVIDER; END;`""),
  ("-d 'master' -Q `"ALTER ROLE [dbmanager] ADD MEMBER [${environment}_${application}_db_owner_mi];`"")
)

# Building the array to include all the databases on the list
foreach ($database in $database_list) {
    $queries += (
      ("-d '$database' -Q `"IF NOT EXISTS(SELECT name FROM sys.sysusers WHERE name = '${environment}_${application}_db_owner') BEGIN; CREATE USER [${environment}_${application}_db_owner] FROM EXTERNAL PROVIDER; END;`""),
      ("-d '$database' -Q `"IF NOT EXISTS(SELECT name FROM sys.sysusers WHERE name = '${environment}_${application}_db_reader') BEGIN; CREATE USER [${environment}_${application}_db_reader] FROM EXTERNAL PROVIDER; END;`""),
      ("-d '$database' -Q `"IF NOT EXISTS(SELECT name FROM sys.sysusers WHERE name = '${environment}_${application}_db_writer') BEGIN; CREATE USER [${environment}_${application}_db_writer] FROM EXTERNAL PROVIDER; END;`""),

      ("-d '$database' -Q `"IF NOT EXISTS(SELECT name FROM sys.sysusers WHERE name = '${environment}_${application}_db_owner_mi') BEGIN; CREATE USER [${environment}_${application}_db_owner_mi] FROM EXTERNAL PROVIDER; END;`""),
      ("-d '$database' -Q `"IF NOT EXISTS(SELECT name FROM sys.sysusers WHERE name = '${environment}_${application}_db_reader_mi') BEGIN; CREATE USER [${environment}_${application}_db_reader_mi] FROM EXTERNAL PROVIDER; END;`""),
      ("-d '$database' -Q `"IF NOT EXISTS(SELECT name FROM sys.sysusers WHERE name = '${environment}_${application}_db_writer_mi') BEGIN; CREATE USER [${environment}_${application}_db_writer_mi] FROM EXTERNAL PROVIDER; END;`""),

      ("-d '$database' -Q `"ALTER ROLE [db_owner] ADD MEMBER [${environment}_${application}_db_owner];`""),
      ("-d '$database' -Q `"ALTER ROLE [db_datareader] ADD MEMBER [${environment}_${application}_db_reader];`""),
      ("-d '$database' -Q `"ALTER ROLE [db_datawriter] ADD MEMBER [${environment}_${application}_db_writer];`""),

      ("-d '$database' -Q `"ALTER ROLE [db_owner] ADD MEMBER [${environment}_${application}_db_owner_mi];`""),
      ("-d '$database' -Q `"ALTER ROLE [db_datareader] ADD MEMBER [${environment}_${application}_db_reader_mi];`""),
      ("-d '$database' -Q `"ALTER ROLE [db_datawriter] ADD MEMBER [${environment}_${application}_db_writer_mi];`"")
    )
}

Start-Sleep -Seconds 120
# Checking if the the Managed Instance groups from Azure AD
if (!(az ad group show --group "${environment}_${application}_db_owner_mi")) {
  az ad group create --display-name "${environment}_${application}_db_owner_mi" --mail-nickname "${environment}_${application}_db_owner_mi"
  # Provides time for the account to be created accross Azure
  Start-Sleep -Seconds 30
}

if (!(az ad group show --group "${environment}_${application}_db_reader_mi")) {
  az ad group create --display-name "${environment}_${application}_db_reader_mi" --mail-nickname "${environment}_${application}_db_reader_mi"
  # Provides time for the account to be created accross Azure
  Start-Sleep -Seconds 30
}

if (!(az ad group show --group "${environment}_${application}_db_writer_mi")) {
  az ad group create --display-name "${environment}_${application}_db_writer_mi" --mail-nickname "${environment}_${application}_db_writer_mi"
  # Provides time for the account to be created accross Azure
  Start-Sleep -Seconds 30
}

foreach ($query in $queries) {
  $a = "SQLCMD.EXE -P '${sql_ad_password}' -U '${sql_ad_login}' -S '${sql_server_name}.database.windows.net' -G $query"
  Invoke-Expression $a
}

# Setting Hiscox zSQLAdmin as SQL Server AD Administrator
Set-AzSqlServerActiveDirectoryAdministrator -DisplayName 'zSQLAdmin' -ObjectId '479b5eeb-8d11-4d9e-ad30-87003ed1b4d2' -ResourceGroupName "${resource_group}" -ServerName "${sql_server_name}" 