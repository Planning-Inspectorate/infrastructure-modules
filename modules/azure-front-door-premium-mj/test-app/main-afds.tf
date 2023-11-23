module "Front_Door" {
  source = "../frontdoor"

  azure = {
    resource_group_name = "rg-smiling-swine"
    location            = "uk-south"
  }

  name = "Front-Door-Standard"

  endpoints = {
    "back-office-endpoint" = { # Endpoint Name
      routes = {
        back-office-route = {               # must define an origin group that is created by the same module
          origin_group_name = "back-office" # name is the same as origin group
        }
      }
    },
    "applications-endpoint" = { # Endpoint Name
      routes = {
        applications-route = {               # must define an origin group that is created by the same module
          origin_group_name = "applications" # name is the same as origin group
        }
      }
    }
  }

  origin_groups = {
    "back-office" = {
      health_probe             = {}
      session_affinity_enabled = false

      origins = {
        webapp-arkate-001 = {
          hostname = "webapp-arkate-001.azurewebsites.net"
        }
        webapp-arkate-002 = {
          hostname = "webapp-arkate-002.azurewebsites.net"
        }
      }
    },
    "applications" = {
      health_probe             = {}
      session_affinity_enabled = false

      origins = {
        webapp-arkate-002 = {
          hostname = "webapp-arkate-002.azurewebsites.net"
        }
      }
    }
  }
}
