$ProgressPreference = "SilentlyContinue"
$ErrorActionPreference = "Stop"

$ipaddresses = '${waf_ip_addresses}' | ConvertFrom-Json
$licenses = '${waf_license_keys}' | ConvertFrom-Json
$sku = "${waf_sku}"
$password = "${waf_password}"
$secret = "${waf_cluster_secret}"
$workspaceid = "${waf_oms_workspace_id}"
$workspacekey = "${waf_oms_workspace_key}"

function Set-TrustAllCertsPolicy {
  if ([System.Net.ServicePointManager]::CertificatePolicy.ToString() -eq "TrustAllCertsPolicy") {
    Write-Verbose "Current policy is already set to TrustAllCertsPolicy"
  }
  else {
    add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
  public bool CheckValidationResult(
    ServicePoint srvPoint, X509Certificate certificate,
    WebRequest request, int certificateProblem) {
    return true;
  }
}
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
  }
}

function Wait-Waf([string]$ip) {
  $tries = 0
  $test = Test-NetConnection -ComputerName $ip -Port 8443
  while ($tries -lt 10 -and $test.TcpTestSucceeded -eq $false) {
    $test = Test-NetConnection -ComputerName $ip -Port 8443
    $tries++
    Start-Sleep -Seconds 30
  }
  if ($test.TcpTestSucceeded -eq $false) {
    throw "Timeout waiting for $ip to be available"
  }
}

function Install-License([string[]]$ipaddresses, [string[]]$licenses, [string]$sku) {
  for ($i = 0; $i -lt $ipaddresses.Count; $i++) {
    $ip = $ipaddresses[$i]
    $url = "http://$ip" + ":8000"
    if ($sku -eq "byol") {
      $license = $licenses[$i]
      $postParams = @{
        token                 = $license
        system_default_domain = "azure.hiscox.com"
      }
      Invoke-RestMethod "$url/token" -Method Post -ContentType "application/x-www-form-urlencoded" -Body $postParams
    }
    $waitResult = Invoke-RestMethod $url
    while ($waitResult.Contains("Please wait while the system starts up")) {
      Start-Sleep -Seconds 30
      $waitResult = Invoke-RestMethod $url
    }
    $eulasign = @{
      name_sign     = "user"
      email_sign    = "user@hiscox.com"
      company_sign  = "Hiscox"
      eula_hash_val = "ed4480205f84cde3e6bdce0c987348d1d90de9db"
      action        = "save_signed_eula"
    }
    Invoke-RestMethod $url -Method Post -Body $eulasign
  }
}

function Get-Header([string]$ipaddress, [string]$password) {
  $secureUrl = "https://$ipaddress" + ":8443"
  $apiendpoint = $secureUrl + "/restapi/v3"
  $login = @{ username = "admin"; password = $password } | ConvertTo-Json
  $token = Invoke-RestMethod -Method Post -Uri "$apiendpoint/login" -ContentType "application/json" -Body $login -Verbose
  $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:" -f $token.token)))
  return @{
    Authorization = "Basic $base64AuthInfo";
    accept        = "application/json"
  }
}

function Set-OmsLog([string]$ipaddress, [string]$password, [string]$workspaceid, [string]$workspacekey) {
  $secureUrl = "https://$ipaddress" + ":8443"
  $apiendpoint = $secureUrl + "/restapi/v3"
  $headers = Get-Header -ipaddress $ipaddress -password $password
  $bodysyslogservers = @{
    "name"           = "oms"
    "server-type"    = "Microsoft Azure OMS"
    "oms-workspace"  = $workspaceid
    "oms-key"        = $workspacekey
    "oms-custom-log" = "All"
  } | ConvertTo-Json
  $bodysyslogsettings = @{
    "web-firewall-log-facility"     = "local0"
    "access-log-facility"           = "local1"
    "audit-log-facility"            = "local2"
    "syslog-facility"               = "local3"
    "network-firewall-log-facility" = "local4"
  } | ConvertTo-Json
  $bodyexportlogfilters = @{
    "system-log-severity"       = "5-Notice"
    "web-firewall-log-severity" = "4-Warning"
  } | ConvertTo-Json
  $bodylogsformat = @{
    "syslog-headers"                    = "ArcSight Log Header"
    "access-logs-standard-format"       = "Microsoft Azure OMS"
    "system-logs-standard-format"       = "Microsoft Azure OMS"
    "web-firewall-logs-standard-format" = "Microsoft Azure OMS"
    "audit-logs-standard-format"        = "Microsoft Azure OMS"
    "network-logs-standard-format"      = "Microsoft Azure OMS"
  } | ConvertTo-Json
  try {
    Invoke-RestMethod -Method Post -Uri "$apiendpoint/syslog-servers" -ContentType "application/json" -Headers $headers -Body $bodysyslogservers -Verbose
    Invoke-RestMethod -Method Put -Uri "$apiendpoint/system/syslog-settings" -ContentType "application/json" -Headers $headers -Body $bodysyslogsettings -Verbose
    Invoke-RestMethod -Method Put -Uri "$apiendpoint/system/export-log-filters" -ContentType "application/json" -Headers $headers -Body $bodyexportlogfilters -Verbose
    Invoke-RestMethod -Method Put -Uri "$apiendpoint/system/logs-format" -ContentType "application/json" -Headers $headers -Body $bodylogsformat -Verbose
  }
  catch {
    if ($responseStream = $_.Exception.Response) {
      $responseStream = $_.Exception.Response.GetResponseStream()
      $readStream = New-Object System.IO.StreamReader($responseStream)
      $errorText = $readStream.ReadToEnd()
      $readStream.Close()
      $_.Exception.Response.Close()
      throw $errorText
    } else {
      throw $_
    }
  }
}

function Set-Hostname([string[]]$ipaddresses, [string]$password) {
  for ($i = 0; $i -lt $ipaddresses.Count; $i++) {
    $ip = $ipaddresses[$i]
    $secureUrl = "https://$ip" + ":8443"
    $apiendpoint = $secureUrl + "/restapi/v3"
    $login = @{ username = "admin"; password = $password } | ConvertTo-Json
    $token = Invoke-RestMethod -Method Post -Uri "$apiendpoint/login" -ContentType "application/json" -Body $login -Verbose
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:" -f $token.token)))
    $headers = @{
      Authorization = "Basic $base64AuthInfo";
      accept        = "application/json"
    }
    $body = @{ "hostname" = "barracuda$i"; "domain" = "azure.hiscox.com" } | ConvertTo-Json
    try {
      Invoke-RestMethod -Method Put -Uri "$apiendpoint/system" -ContentType "application/json" -Headers $headers -Body $body -Verbose -MaximumRedirection 0 -ErrorAction SilentlyContinue
    }
    catch {
      $responseStream = $_.Exception.Response.GetResponseStream()
      $readStream = New-Object System.IO.StreamReader($responseStream)
      $errorText = $readStream.ReadToEnd()
      $readStream.Close()
      $_.Exception.Response.Close()
      throw $errorText
    }
  }
}

function Create-Cluster([string[]]$ipaddresses, [string]$password, [string]$secret) {
  for ($i = 0; $i -lt $ipaddresses.Count; $i++) {
    $ip = $ipaddresses[$i]
    $secureUrl = "https://$ip" + ":8443"
    $apiendpoint = $secureUrl + "/restapi/v3"
    $login = @{ username = "admin"; password = $password } | ConvertTo-Json
    $token = Invoke-RestMethod -Method Post -Uri "$apiendpoint/login" -ContentType "application/json" -Body $login -Verbose
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:" -f $token.token)))
    $headers = @{
      Authorization = "Basic $base64AuthInfo";
      accept        = "application/json"
    }
    $body = @{ "cluster-name" = "cluster"; "cluster-shared-secret" = $secret } | ConvertTo-Json
    try {
      Invoke-RestMethod -Method Put -Uri "$apiendpoint/cluster" -ContentType "application/json" -Headers $headers -Body $body -Verbose -MaximumRedirection 0 -ErrorAction SilentlyContinue
    }
    catch {
      $responseStream = $_.Exception.Response.GetResponseStream()
      $readStream = New-Object System.IO.StreamReader($responseStream)
      $errorText = $readStream.ReadToEnd()
      $readStream.Close()
      $_.Exception.Response.Close()
      throw $errorText
    }
    if ($i -gt 0) {
      Start-Sleep -Seconds 120
      $join = @{ "ip-address" = $ipaddresses[0] } | ConvertTo-Json
      try {
        Invoke-RestMethod -Method Post -Uri "$apiendpoint/cluster/nodes" -ContentType "application/json" -Headers $headers -Body $join -Verbose
      }
      catch {
        $responseStream = $_.Exception.Response.GetResponseStream()
        $readStream = New-Object System.IO.StreamReader($responseStream)
        $errorText = $readStream.ReadToEnd()
        $readStream.Close()
        $_.Exception.Response.Close()
        throw $errorText
      }
    }
  }
}

Set-TrustAllCertsPolicy
Install-License -ipaddresses $ipaddresses -licenses $licenses -sku $sku
foreach ($ip in $ipaddresses) {
  Wait-Waf -ip $ip
}
Set-Hostname -ipaddresses $ipaddresses -password $password
Create-Cluster -ipaddresses $ipaddresses -password $password -secret $secret
if ($workspaceid -ne "waf_oms_workspace_id") {
  Set-OmsLog -ipaddress $ipaddresses[0] -password $password -workspaceid $workspaceid -workspacekey $workspacekey
}

