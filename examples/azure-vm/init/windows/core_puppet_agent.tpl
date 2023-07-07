& netsh.exe Advfirewall set allprofiles state off

$certName = $env:COMPUTERNAME + ".${dns_suffix}"
$certName = $certName.ToLower() #Puppet cert names must be lower case

[system.io.directory]::CreateDirectory("C:\ProgramData\PuppetLabs\code\environments\${puppet_agent_environment}")

[System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = New-Object System.Net.WebClient
$webClient.DownloadFile('https://${puppet_master}:8140/packages/current/install.ps1', 'install.ps1')
.\install.ps1 -v main:certname=$certName agent:environment=${puppet_agent_environment} custom_attributes:challengePassword=${puppet_autosign_key} extension_requests:pp_role=${puppet_role}