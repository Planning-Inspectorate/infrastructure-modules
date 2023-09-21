# call in the source

# you need to fill in the blanks that will launch the resource

module "azure-front-door" {
  source = "../"

  azure = {
    resource_group_name = "pins-rg-common-front-door-dev-ukw-001"
    location            = "uk-south" # does this need to match the rg above and be in west?
  }

  name = "front-door-standard" # this should match the other naming convention

  origin_groups = {
    # "common-dev" = {
    #   health_probe             = {}
    #   session_affinity_enabled = false

    #   origins = {
    #     webapp-uswest = {
    #       hostname = "www.gov.uk" # this would be the name of the webapp, or the url?
    #     }
    #     webapp-useast = { # backup region
    #       hostname = "www.gov.uk"
    #     }
    #   }
    # }
    "back-office-dev" = {
      health_probe             = {}
      session_affinity_enabled = false

      origins = {
        webapp-uswest = {
          hostname = "back-office-dev.planninginspectorate.gov.uk" # this would be the name of the webapp, or the url?
        }
        # webapp-useast = { # backup region
        #   hostname = "www.gov.uk"
        # }
      }
    }
    # "back-office-appeals-dev" = {
    #   health_probe             = {}
    #   session_affinity_enabled = false

    #   origins = {
    #     webapp-uswest = {
    #       hostname = "www.gov.uk" # this would be the name of the webapp, or the url?
    #     }
    #   }
    # }
    # "applications-service-dev" = {
    #   health_probe             = {}
    #   session_affinity_enabled = false

    #   origins = {
    #     webapp-uswest = {
    #       hostname = "www.gov.uk" # this would be the name of the webapp, or the url?
    #     }
    #   }
    # }
    # "appeals-service-dev" = {
    #   health_probe             = {}
    #   session_affinity_enabled = false

    #   origins = {
    #     webapp-uswest = {
    #       hostname = "www.gov.uk" # this would be the name of the webapp, or the url?
    #     }
    #   }
    # }
  }

  endpoints = {
    # "pins-fdp-common-dev-001" = { # or pins-fd-common-dev-001.azurefd.net # is it even needed?
    #   routes = {
    #     common-dev-route = { # must define an origin group that is created by the same module
    #       origin_group_name = "common-dev"
    #     }
    #   }
    # }
    "back-office-dev.planninginspectorate.gov.uk" = {
      routes = {
        back-office-dev-route = { # must define an origin group that is created by the same module
          origin_group_name = "back-office-dev"
        }
      }
    }
    # "back-office-appeals-dev.planninginspectorate.gov.uk" = {
    #   routes = {
    #     back-office-appeals-dev-route = { # must define an origin group that is created by the same module
    #       origin_group_name = "back-office-appeals-dev"
    #     }
    #   }
    # }
    # "applications-service-dev.planninginspectorate.gov.uk" = {
    #   routes = {
    #     applications-dev-route = { # must define an origin group that is created by the same module
    #       origin_group_name = "applications-service-dev"
    #     }
    #   }
    # }
    # "appeals-service-dev.planninginspectorate.gov.uk" = {
    #   routes = {
    #     appeals-dev-route = { # must define an origin group that is created by the same module
    #       origin_group_name = "appeals-service-dev"
    #     }
    #   }
    # }
  }
}
