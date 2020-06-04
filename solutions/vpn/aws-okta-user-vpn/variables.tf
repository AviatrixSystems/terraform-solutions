variable "aws_account_name" { default = "aws-network" }
variable "aws_region" { default = "us-west-2" }

variable "uservpn_vpc" { default = "AWS-UW2-SAML-VPN-VPC" }
variable "uservpn_vpc_cidr" { default = "10.22.0.0/16" }

variable "vpn_gw1_name" { default = "AWS-UW2-SAML-VPN-GW-1" }
variable "vpn_gw1_size" { default = "t3.small" }
variable "vpn_gw1_subnet" { default = "10.22.80.0/20" }
variable "vpn_gw1_vpn_cidr" { default = "192.168.43.0/24" }

variable "vpn_gw2_name" { default = "AWS-UW2-SAML-VPN-GW-2" }
variable "vpn_gw2_size" { default = "t3.small" }
variable "vpn_gw2_subnet" { default = "10.22.96.0/20" }
variable "vpn_gw2_vpn_cidr" { default = "192.168.44.0/24" }

variable "max_vpn_conn" { default = "100" }
variable "enable_elb" { default = true }
variable "enable_vpn_nat" { default = true }
variable "split_tunnel" { default = true }
variable "additional_cidrs" { default = "10.21.0.0/16,10.25.0.0/16,10.26.0.0/16" }
variable "saml_enabled" { default = true }

variable "vpn_user" { default = "aws-okta-shared-cert" }

variable "vpn_profile_name" { default = "Developer-Profile" }
variable "vpn_profile_base_rule" { default = "deny_all" }

variable "vpn_profile_policy1_action" { default = "allow" }
variable "vpn_profile_policy1_proto" { default = "all" }
variable "vpn_profile_policy1_port" { default = "0:65535" }
variable "vpn_profile_policy1_target" { default = "10.25.0.0/16" }

variable "vpn_profile_policy2_action" { default = "allow" }
variable "vpn_profile_policy2_proto" { default = "all" }
variable "vpn_profile_policy2_port" { default = "0:65535" }
variable "vpn_profile_policy2_target" { default = "10.26.0.0/16" }

variable "saml_endpoint_name" { default = "okta_uservpn" }

# Expected as environment variable.  See setup.sh.
variable "AVX_CONTROLLER_IP" {}

# Expected as environment variables.  See setup.sh.
variable "OKTA_ORG_NAME" {}
variable "OKTA_BASE_URL" {}
variable "OKTA_API_TOKEN" {}

variable "okta_user1_first_name" { default = "Steve" }
variable "okta_user1_last_name" { default = "Developer" }
variable "okta_user1_login" { default = "steve@abc.com" }
variable "okta_user1_email" { default = "steve@abc.com" }
variable "okta_app_name" { default = "Aviatrix User VPN" }

