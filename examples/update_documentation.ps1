# This script scrapes directories and will run `terraform fmt` and generate module README.md files.

# Before running this script it is advised that you commit any code changes you have made - in the event this ruins something rolling back is easier
# You need to have terraform and terraform-docs installed
$ErrorActionPreference = "Stop"

function Format-Modules {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string[]]$Directories
	)
	foreach ($dir in $Directories) {
		Write-Host "Formatting $dir"
		Push-Location -LiteralPath $dir
		& terraform fmt
		Pop-Location
	}
}

function Update-Readmes {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string[]]$Directories
	)
	foreach ($dir in $Directories) {
		Write-Host "Generating docs for $dir"
		Push-Location -LiteralPath $dir
		& terraform-docs md . | Out-File README.md
		Pop-Location
	}
}
# ensures you have the required tools
Get-Command terraform.exe
Get-Command terraform-docs.exe

# Get modules
$modules = Get-ChildItem -Directory | where Name -Like "azure-*" | select -expand fullname
Format-Modules -Directories $modules
Update-Readmes -Directories $modules

# Get CI pipeline wrappers
$ci = Get-ChildItem -Path ci-pipeline-modules -Directory | select -expand fullname
Format-Modules -Directories $ci
Update-Readmes -Directories $ci

# Get examples
$examples = Get-ChildItem -Path examples -Directory | select -expand fullname
Format-Modules -Directories $examples
Update-Readmes -Directories $examples
