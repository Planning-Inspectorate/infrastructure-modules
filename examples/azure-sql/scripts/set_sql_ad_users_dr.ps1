# Adding the required groups to the default Master database
$queries = @(
  ("-d 'master' -Q `"IF NOT EXISTS(SELECT name FROM sys.sysusers WHERE name = '${environment}_${application}_db_owner_mi') BEGIN; CREATE USER [${environment}_${application}_db_owner_mi] FROM EXTERNAL PROVIDER; END;`""),
  ("-d 'master' -Q `"ALTER ROLE [dbmanager] ADD MEMBER [${environment}_${application}_db_owner_mi];`"")
)

foreach ($query in $queries) {
  $a = "SQLCMD.EXE -P '${sql_ad_password}' -U '${sql_ad_login}' -S '${sql_server_name}.database.windows.net' -G $query"
  Invoke-Expression $a
}

# Setting Hiscox zSQLAdmin as SQL Server AD Administrator
az sql server ad-admin update --display-name "zSQLAdmin" --resource-group "${resource_group}" --server-name "${sql_server_name}"