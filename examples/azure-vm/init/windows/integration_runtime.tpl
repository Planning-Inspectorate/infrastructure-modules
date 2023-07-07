$gatewayKey = "${shir_auth_key}"
$certDomain = "${shir_certificate_domain}"
$certName = "${shir_certificate_name}"
$secretName = "${shir_secret_name}"
$keyVaultName = "${shir_key_vault_name}"

# init log setting
$logLoc = "$env:SystemDrive\WindowsAzure\Logs\Plugins\Microsoft.Compute.CustomScriptExtension\"
if (! (Test-Path($logLoc)))
{
    New-Item -path $logLoc -type directory -Force
}
$logPath = "$logLoc\tracelog.log"
"Start to excute SHIR install script. `n" | Out-File $logPath

function Now-Value()
{
    return (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
}

function Throw-Error([string] $msg)
{
	try 
	{
		throw $msg
	} 
	catch 
	{
		$stack = $_.ScriptStackTrace
		Trace-Log "DMDTTP is failed: $msg`nStack:`n$stack"
	}

	throw $msg
}

function Trace-Log([string] $msg)
{
    $now = Now-Value
    try
    {
        "$($now) $msg`n" | Out-File $logPath -Append
    }
    catch
    {
        #ignore any exception during trace
    }

}

function Run-Process([string] $process, [string] $arguments)
{
	Write-Verbose "Run-Process: $process $arguments"
	
	$errorFile = "$env:tmp\tmp$pid.err"
	$outFile = "$env:tmp\tmp$pid.out"
	"" | Out-File $outFile
	"" | Out-File $errorFile	

	$errVariable = ""

	if ([string]::IsNullOrEmpty($arguments))
	{
		$proc = Start-Process -FilePath $process -Wait -Passthru -NoNewWindow `
			-RedirectStandardError $errorFile -RedirectStandardOutput $outFile -ErrorVariable errVariable
	}
	else
	{
		$proc = Start-Process -FilePath $process -ArgumentList $arguments -Wait -Passthru -NoNewWindow `
			-RedirectStandardError $errorFile -RedirectStandardOutput $outFile -ErrorVariable errVariable
	}
	
	$errContent = [string] (Get-Content -Path $errorFile -Delimiter "!!!DoesNotExist!!!")
	$outContent = [string] (Get-Content -Path $outFile -Delimiter "!!!DoesNotExist!!!")

	Remove-Item $errorFile
	Remove-Item $outFile

	if($proc.ExitCode -ne 0 -or $errVariable -ne "")
	{		
		Throw-Error "Failed to run process: exitCode=$($proc.ExitCode), errVariable=$errVariable, errContent=$errContent, outContent=$outContent."
	}

	Trace-Log "Run-Process: ExitCode=$($proc.ExitCode), output=$outContent"

	if ([string]::IsNullOrEmpty($outContent))
	{
		return $outContent
	}

	return $outContent.Trim()
}

function Download-Gateway([string] $url, [string] $gwPath)
{
    try
    {
        $ErrorActionPreference = "Stop";
        $client = New-Object System.Net.WebClient
        $client.DownloadFile($url, $gwPath)
        Trace-Log "Download gateway successfully. Gateway loc: $gwPath"
    }
    catch
    {
        Trace-Log "Fail to download gateway msi"
        Trace-Log $_.Exception.ToString()
        throw
    }
}

function Install-Gateway([string] $gwPath)
{
	if ([string]::IsNullOrEmpty($gwPath))
    {
		Throw-Error "Gateway path is not specified"
    }

	if (!(Test-Path -Path $gwPath))
	{
		Throw-Error "Invalid gateway path: $gwPath"
	}
	
	Trace-Log "Start Gateway installation"
	Run-Process "msiexec.exe" "/i gateway.msi INSTALLTYPE=AzureTemplate /quiet /norestart"		
	
	Start-Sleep -Seconds 30	

	Trace-Log "Installation of gateway is successful"
}

function Get-RegistryProperty([string] $keyPath, [string] $property)
{
	Trace-Log "Get-RegistryProperty: Get $property from $keyPath"
	if (! (Test-Path $keyPath))
	{
		Trace-Log "Get-RegistryProperty: $keyPath does not exist"
	}

	$keyReg = Get-Item $keyPath
	if (! ($keyReg.Property -contains $property))
	{
		Trace-Log "Get-RegistryProperty: $property does not exist"
		return ""
	}

	return $keyReg.GetValue($property)
}

function Get-InstalledFilePath()
{
	$filePath = Get-RegistryProperty "hklm:\Software\Microsoft\DataTransfer\DataManagementGateway\ConfigurationManager" "DiacmdPath"
	if ([string]::IsNullOrEmpty($filePath))
	{
		Throw-Error "Get-InstalledFilePath: Cannot find installed File Path"
	}
    Trace-Log "Gateway installation file: $filePath"

	return $filePath
}

function Register-Gateway([string] $instanceKey)
{
    Trace-Log "Register Agent"
	$filePath = Get-InstalledFilePath
	Run-Process $filePath "-era 8060"
	Run-Process $filePath "-k $instanceKey"
    Trace-Log "Agent registration is successful!"
}

function Get-AzureAuthToken()
{
	$access_token = ((Invoke-WebRequest -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' -Method GET -Headers @{Metadata="true"}).Content | ConvertFrom-Json).access_token
	return $access_token
}

function Get-Certificate([string]$keyVaultName,[string]$certDomain,[string]$certName,[string]$secretName,[string]$certPath="$($env:TEMP)\cert.pfx")
{
	$access_token = Get-AzureAuthToken
	$certPfxPassword = ((Invoke-WebRequest -Uri https://$($keyVaultName).vault.azure.net/secrets/$($secretName)?api-version=2016-10-01 -Method GET -Headers @{Authorization="Bearer $access_token"}).content | ConvertFrom-Json).value
	$certSecurePassword = $certPfxPassword | ConvertTo-SecureString -AsPlainText -Force

	$certContent = ((Invoke-WebRequest -Uri https://$($keyVaultName).vault.azure.net/secrets/$($certName)?api-version=2016-10-01 -Method GET -Headers @{Authorization="Bearer $access_token"}).content | ConvertFrom-Json).value

	# Azure strips the password to protect the private key so we need to put it back
	$certSecretBytes = [System.Convert]::FromBase64String($certContent)
	$certCollection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
	$certCollection.Import($certSecretBytes,$null,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
	$protectedCertificateBytes = $certCollection.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $certPfxPassword)

	# Export pfx certificate to where we need it
	[System.IO.File]::WriteAllBytes($certPath, $protectedCertificateBytes) 

	# Import to local Windows certificate store
	Import-PfxCertificate -FilePath $certPath -CertStoreLocation Cert:\LocalMachine\My -Password $certSecurePassword

	# Clean up - don't leave certs lying around!
	Remove-Item $certPath

	# Get thumbprint of installed cert
	$thumbprints = Get-ChildItem -Path Cert:\LocalMachine\My | ? {$_.Subject -match $certDomain}  
	$certThumbprint = $thumbprints[0].Thumbprint  
	return $certThumbprint
}

function Set-GatewayCertificate([string]$certThumbprint,[int]$port=8060)
{
    Trace-Log "Set Gateway Remote Access"
	$filePath = Get-InstalledFilePath
	Run-Process $filePath "-era $port $certThumprint"
    Trace-Log "Agent secure remote access config is successful!"
}



Trace-Log "Log file: $logLoc"
$uri = "https://go.microsoft.com/fwlink/?linkid=839822"
Trace-Log "Gateway download fw link: $uri"
$gwPath= "$PWD\gateway.msi"
Trace-Log "Gateway download location: $gwPath"


Download-Gateway $uri $gwPath
Install-Gateway $gwPath

Register-Gateway $gatewayKey

#$certThumbprint = Get-Certificate $keyVaultName $certDomain $certName $secretName
#Set-GatewayCertificate $certThumbprint