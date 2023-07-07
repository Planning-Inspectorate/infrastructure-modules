# Some processing to sort out all the object IDs

locals {

  # Separate different types of list entry (user/group/sp)
  upn_source = [for x in var.assignments :
    {
      user = lower(x.user)
      role = x.role
    }
    if lookup(x, "user", null) != null
  ]

  group_source = [for x in var.assignments :
    {
      group = x.group
      role  = x.role
    }
    if lookup(x, "group", null) != null
  ]

  sp_source = [for x in var.assignments :
    {
      service_principal = x.service_principal
      role              = x.role
    }
    if lookup(x, "service_principal", null) != null
  ]

  upn_list   = distinct([for x in local.upn_source : x.user])
  group_list = distinct([for x in local.group_source : x.group])
  sp_list    = distinct([for x in local.sp_source : x.service_principal])

  # Get the remaining list entries where ID is already specified
  id_data = [for x in var.assignments : x if lookup(x, "id", null) != null]

  # Create lookup tables for those user/group/sp object IDs
  upn_lookup   = { for u in data.azuread_user.user : lower(u.user_principal_name) => u.id }
  group_lookup = { for g in data.azuread_group.group : g.display_name => g.id }
  sp_lookup    = { for s in data.azuread_service_principal.sp : s.display_name => s.id }

  # Use it to create new lists where the user/group/sp names are replaced with the looked up IDs
  upn_data = [for x in local.upn_source :
    {
      id   = lookup(local.upn_lookup, lower(x.user))
      role = x.role
    }
  ]

  group_data = [for x in local.group_source :
    {
      id   = lookup(local.group_lookup, x.group)
      role = x.role
    }
  ]

  sp_data = [for x in local.sp_source :
    {
      id   = lookup(local.sp_lookup, x.service_principal)
      role = x.role
    }
  ]


  # Merge this with the other IDs supplied
  all_ids = concat(local.id_data, local.upn_data, local.group_data, local.sp_data)

  # Can then create the list of maps, containing {scope="", role="", id=""}
  all_assignments = concat(flatten([for s in data.azurerm_resource_group.rg :
    [for x in local.all_ids :
      {
        scope = s.id
        role  = x.role
        id    = x.id
      }
    ]
  ]))
}
