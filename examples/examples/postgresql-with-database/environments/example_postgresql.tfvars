/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

application = "tfmodulesexample"

location = "northeurope"

postgresql_database = [ 
    { 
        name      = "postgresql_exampledb_1"
    },
 #   { 
 #       name      = "postgresql_exampledb_2"
 #       collation = "en-US"
 #   },
  ]