Get-CimInstance -ClassName Win32_Volume -Filter 'DriveType = 5' |
  Set-CimInstance -Property @{ DriveLetter = $null }

function Get-PhysicalDiskByLun([int[]]$luns) {
    $disks = get-storagenode | where-object name -match $env:computername | get-physicaldisk | where-object canpool
    $newDisks = @()
    foreach ($disk in $disks) {
        $lun = ((($disk.PhysicalLocation.Split(":") | where { $_.Contains("LUN") } ) -split '\s+' ) | where { $_ -match '^\d+$' }).trim()
        $disk | Add-Member -NotePropertyName Lun -NotePropertyValue $lun -TypeName Integer
        $newDisks += $disk
    }
    return $newDisks | where-object { $luns -contains [int]$_.Lun }
}

function Wait-Disk([int]$expected) {
  $limit = (Get-Date).AddMinutes(10)
  $current = @(Get-StorageNode | Where-Object Name -Match $env:COMPUTERNAME | Get-PhysicalDisk).Count - 2
  while ($expected -ne $current -and (Get-Date) -le $limit) {
    Start-Sleep -Seconds 10
    $current = @(Get-StorageNode | Where-Object Name -Match $env:COMPUTERNAME | Get-PhysicalDisk).Count - 2
  }
}

$configs = @()
$configs = ('${data_disk}' | ConvertFrom-Json)

if ($configs.Count -gt 0){
  Wait-Disk -expected $configs.disk_luns.Count
}

foreach ($config in $configs) {
  $driveletter = $config.drive_letter
  $physicaldisk = Get-PhysicalDiskByLun -lun $config.disk_luns
  if ($config.disk_luns.Count -eq 1) {
    $disk = Get-Disk -UniqueId $physicaldisk.UniqueId
    $params = @{
      FileSystem         = "NTFS"
      NewFileSystemLabel = $config.label
      AllocationUnitSize = $config.allocation_unit_size
    }
    $disk | Initialize-Disk -PartitionStyle GPT -PassThru |
      New-Partition -UseMaximumSize -DriveLetter $driveletter |
      Format-Volume @params -Confirm:$false -Force
  }
  elseif ($config.disk_luns.Count -gt 1) {
    $paramspool = @{
      FriendlyName                 = $config.label
      StorageSubSystemFriendlyName = 'Windows Storage*'
      PhysicalDisks                = $physicaldisk
    }
    $paramsdisk = @{
      FriendlyName          = $config.label
      ResiliencySettingName = "Simple"
      UseMaximumSize        = $true
      Interleave            = $config.interleave
      NumberOfColumns       = $config.disk_luns.Count
    }
    $paramsvolume = @{
      FriendlyName       = $config.label
      AllocationUnitSize = $config.allocation_unit_size
      DriveLetter        = $driveletter
      FileSystem         = "NTFS"
    }

    New-StoragePool @paramspool | New-VirtualDisk @paramsdisk | Get-Disk | New-Volume @paramsvolume
  }
}