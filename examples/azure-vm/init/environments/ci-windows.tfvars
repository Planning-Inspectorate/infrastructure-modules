os_family = "windows"

init_scripts = [
    "puppet_agent",
    "custom",
    "data_disk"
]

custom = "Write-Host \"Hello, there!\""

data_disk = [
  {
    drive_letter         = "e"
    label                = "data"
    disk_luns            = [0,1,2,3]
    interleave           = 65536
    allocation_unit_size = 65536
  },
  {
    drive_letter         = "f"
    label                = "logs"
    disk_luns            = [4]
    interleave           = null
    allocation_unit_size = 4096
  },
  {
    drive_letter         = "t"
    label                = "backup"
    disk_luns            = [5,6]
    interleave           = 65536
    allocation_unit_size = 65536
  }
]