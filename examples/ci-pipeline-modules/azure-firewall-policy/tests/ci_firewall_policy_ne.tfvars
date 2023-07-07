/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

application = "fwptest"

location = "northeurope"

vnet_rg = "devtest-itspsg-subscription-northeurope"

application_rules = {
	300 = {
		name = "test"
		action = "Deny"
		rules = {
			a_rule_name = {
				source_addresses = ["192.168.0.1"]
				source_ip_groups = []
				destination_fqdns =["bacon.example.com"]
				destination_fqdn_tags = []
				rule_protocols = {
					Https = 443
				}
			}
		}
	}
	350 = {
		name = "test2"
		action = "Allow"
		rules = {
			a_rule_name = {
				source_addresses = ["192.168.0.2"]
				source_ip_groups = []
				destination_fqdns =["mushroom.example.com"]
				destination_fqdn_tags = []
				rule_protocols = {
					Https = 443
					Http = 80
				}
			}
		}
	}
}

network_rules = {
	200 = {
		name = "test3"
		action = "Deny"
		rules = {
			a_rule_name1 = {
				source_addresses = ["192.168.0.3"]
				source_ip_groups = []
				destination_addresses =["192.168.5.0"]
				destination_ip_groups = []
				destination_fqdns = []
				destination_ports = ["80", "1000-2000"]
				protocols = ["TCP", "UDP"]
			}
		}
	}
}

nat_rules = {
	100 = {
		name = "test4"
		action = "Dnat"
		rule_name = "example"
		rule_source_addresses = ["192.168.0.3"]
		rule_source_ip_groups = []
		rule_destination_address = "192.168.253.1"
		rule_destination_ports = ["80"]
		rule_protocols = ["TCP"]
		rule_translated_address = "192.168.20.4"
		rule_translated_port = 8443
	}
}