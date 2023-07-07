/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

application = "exampleeh"

location = "northeurope"

event_hubs = [
    {
      name = "first"
    }
  ]

