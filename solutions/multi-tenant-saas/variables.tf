variable "account_name" { default = "aws-dev" }
variable "region" { default = "eu-north-1" }

### AWS = 1, GCP = 4, Azure = 8, OCI = 16.
variable "cloud_type" { default = 1 }

### VPCs.
variable "vpcs" {
  default = {
    saas_transit = {
      name       = "AWS-EN1-SaaS-Transit-VPC"
      cidr       = "10.60.0.0/16"
      is_transit = true
      is_firenet = false
    }
    saas_services = {
      name       = "AWS-EN1-SaaS-Services-VPC"
      cidr       = "10.61.0.0/16"
      is_transit = false
      is_firenet = false
    }
    customer1 = {
      name       = "AWS-EN1-SaaS-C1-VPC"
      cidr       = "10.62.0.0/16"
      is_transit = false
      is_firenet = false
    }
    customer2 = {
      name       = "AWS-EN1-SaaS-C2-VPC"
      cidr       = "10.63.0.0/16"
      is_transit = false
      is_firenet = false
    }
  }
}

### Customer S2C gateways.
variable "s2c_gateways" {
  default = {
    customer1 = {
      customer = "customer1"
      name     = "AWS-EN1-SaaS-C1-S2C-GW"
      size     = "t3.small"
    }
    customer2 = {
      customer = "customer2"
      name     = "AWS-EN1-SaaS-C2-S2C-GW"
      size     = "t3.small"
    }
  }
}

### Customer Spoke gateways.
variable "spoke_gateways" {
  default = {
    customer1 = {
      customer     = "customer1"
      name         = "AWS-EN1-SaaS-C1-Spoke-GW"
      size         = "t3.small"
      active_mesh  = true
      single_az_ha = true
    }
    customer2 = {
      customer     = "customer2"
      name         = "AWS-EN1-SaaS-C2-Spoke-GW"
      size         = "t3.small"
      active_mesh  = true
      single_az_ha = true
    }
  }
}

### Transit gateway.
variable "transit_gateway" {
  default = {
    name         = "AWS-EN1-SaaS-Transit-GW"
    size         = "t3.small"
    active_mesh  = true
    single_az_ha = true
    vpc          = "saas_transit"
  }
}
