variable "account_name" { default = "aws-network" }
variable "region" { default = "us-west-2" }

variable "uservpn_vpc" { default = "AWS-UW2-SAML-VPN-VPC" }
variable "uservpn_vpc_cidr" { default = "10.22.0.0/16" }

### AWS = 1, GCP = 4, Azure = 8, OCI = 16.
variable "cloud_type" { default = 1 }

### AWS gateways.
variable "vpn_gateways" {
  default = {
    gw1 = {
      name     = "AWS-UW2-SAML-VPN-GW-1"
      size     = "t3.small"
      subnet   = "10.22.80.0/20"
      vpn_cidr = "192.168.43.0/24"
    }
    gw2 = {
      name     = "AWS-UW2-SAML-VPN-GW-2"
      size     = "t3.small"
      subnet   = "10.22.96.0/20"
      vpn_cidr = "192.168.44.0/24"
    }
  }
}

variable "spoke_gateways" {
  default = {
    spoke_gw1 = {
      name                 = "AWS-UW2-VPN-Spoke-GW"
      size                 = "t3.small"
      active_mesh          = true
      single_az_ha         = true
      vpc                  = "uservpn_vpc"
      subnet               = "10.22.80.0/20"
      transit_gateway_name = "AWS-UW2-Transit-GW"
    }
  }
}

### Example for GCP, uncomment as needed.
# variable "account_name" { default = "gcp-network" }
# variable "region" { default = "us-west1-a" }

# variable "uservpn_vpc" { default = "gcp-uw1-saml-vpn-vpc" }
# variable "uservpn_vpc_cidr" { default = "10.83.0.0/16" }

# variable "vpn_gateways" {
#   default = {
#     gw1 = {
#       name = "gcp-uw1-saml-vpn-gw-1"
#       size = "n1-standard-1"
#       subnet = "10.83.0.0/16"
#       vpn_cidr = "192.168.43.0/24"
#     }
#   }
# }

### Example for Azure, uncomment as needed.
# variable "account_name" { default = "azure-network" }
# variable "region" { default = "West US 2" }

# variable "uservpn_vpc" { default = "AZ-WU2-SAML-VPN-VNet" }
# variable "uservpn_vpc_cidr" { default = "10.103.0.0/16" }

# variable "vpn_gateways" {
#   default = {
#     gw1 = {
#       name = "AZ-WU2-SAML-VPN-GW-1"
#       size = "Standard_B1ms"
#       subnet = "10.103.0.0/20"
#       vpn_cidr = "192.168.43.0/24"
#     }
#     gw2 = {
#       name = "AZ-WU2-SAML-VPN-GW-2"
#       size = "Standard_B1ms"
#       subnet = "10.103.16/20"
#       vpn_cidr = "192.168.44.0/24"
#     }
#   }
# }

variable "max_vpn_conn" { default = "50" }
variable "enable_elb" { default = true }
variable "enable_vpn_nat" { default = true }
variable "split_tunnel" { default = true }
variable "additional_cidrs" { default = "10.21.0.0/16,10.25.0.0/16,10.101.0.0/16" }
variable "saml_enabled" { default = true }

variable "vpn_user" { default = "aws-okta-shared-cert" }

variable "vpn_profile_name" { default = "Developer-Profile" }
variable "vpn_profile_base_rule" { default = "deny_all" }
variable "vpn_profile_policies" {
  default = {
    policy1 = {
      action = "allow"
      proto  = "all"
      port   = "0:65535"
      target = "10.25.0.0/16"
    }
    policy2 = {
      action = "allow"
      proto  = "all"
      port   = "0:65535"
      target = "10.101.0.0/16"
    }
  }
}

variable "saml_endpoint_name" { default = "okta_uservpn" }

### Expected as environment variable. See setup.sh.
variable "AVX_CONTROLLER_IP" {}

### Expected as environment variables. See setup.sh.
variable "OKTA_ORG_NAME" {}
variable "OKTA_BASE_URL" {}
variable "OKTA_API_TOKEN" {}

variable "okta_app_name" { default = "Aviatrix User VPN" }

variable "okta_vpn_users" {
  default = {
    user1 = {
      first_name      = "Nicolas"
      last_name       = "Prod"
      login           = "nicolas_prod@abc.com"
      email           = "nicolas_prod@abc.com"
      aviatrixProfile = "Prod-Profile"
    }
    user2 = {
      first_name      = "John"
      last_name       = "Dev"
      login           = "john_dev@abc.com"
      email           = "john_dev@abc.com"
      aviatrixProfile = "Developer-Profile"
    }
  }
}
