/*
    Terraform configuration file defining variable value for this environment
*/
environment = "ci"

application = "fw-with-policy"

location = "northeurope"

vnet_name = "devtest-its-vnet-northeurope"

vnet_rg = "devtest-itspsg-subscription-northeurope"

application_rules = {
	350 = {
		name = "test"
		action = "Deny"
		rules = {
			a_rule_name = {
				source_addresses = ["*"]
				source_ip_groups = []
				destination_fqdns =["google.com"]
				destination_fqdn_tags = []
				rule_protocols = {
					Https = 443
				}
			}
		}
	}
	300 = {
		name = "test2"
		action = "Allow"
		rules = {
			a_rule_name = {
				source_addresses = ["172.20.192.0/21"]
				source_ip_groups = []
				destination_fqdns =["google.com"]
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
				source_addresses = ["*"]
				source_ip_groups = []
				destination_addresses =["8.8.8.8"]
				destination_ip_groups = []
				destination_fqdns = []
				destination_ports = ["53", "1000-2000"]
				protocols = ["TCP", "UDP"]
			}
		}
	}
}

# nat_rules = {
# 	100 = {
# 		name = "test4"
# 		action = "Dnat"
# 		rule_name = "example"
# 		rule_source_addresses = ["192.168.0.3"]
# 		rule_source_ip_groups = []
# 		rule_destination_address = "172.20.194.5"
# 		rule_destination_ports = ["443"]
# 		rule_protocols = ["TCP"]
# 		rule_translated_address = "172.20.195.5"
# 		rule_translated_port = 8443
# 	}
# }

