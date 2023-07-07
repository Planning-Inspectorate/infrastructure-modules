locals {
  header = var.os_family == "windows" ? "$ErrorActionPreference = 'Stop'\n" : "#!/bin/bash\n"
}

