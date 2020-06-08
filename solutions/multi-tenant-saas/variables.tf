variable "account_name" { default = "aws-dev" }
variable "region" { default = "eu-west-1" }

### AWS = 1, GCP = 4, Azure = 8, OCI = 16.
variable "cloud_type" { default = 1 }

### VPCs.
variable "vpcs" {
  default = {
    saas_transit = {
      name       = "AWS-EW1-SaaS-Transit-VPC"
      cidr       = "10.60.0.0/16"
      is_transit = true
      is_firenet = false
    }
    saas_services = {
      name       = "AWS-EW1-SaaS-Services-VPC"
      cidr       = "10.61.0.0/16"
      is_transit = false
      is_firenet = false
    }
    customer1 = {
      name       = "AWS-EW1-SaaS-C1-VPC"
      cidr       = "10.62.0.0/16"
      is_transit = false
      is_firenet = false
    }
    customer2 = {
      name       = "AWS-EW1-SaaS-C2-VPC"
      cidr       = "10.63.0.0/16"
      is_transit = false
      is_firenet = false
    }
  }
}

### Transit gateway.
variable "transit_gateway" {
  default = {
    name         = "AWS-EW1-SaaS-Transit-GW"
    size         = "t3.small"
    active_mesh  = true
    single_az_ha = true
    vpc          = "saas_transit"
  }
}

### Shared services spoke gateway.
variable "services_spoke_gateway" {
  default = {
    name         = "AWS-EW1-Saas-Shared-Services-GW"
    size         = "t3.small"
    active_mesh  = true
    single_az_ha = true
    vpc          = "saas_services"
  }
}

### Customer Spoke gateways.
variable "spoke_gateways" {
  default = {
    customer1 = {
      customer     = "customer1"
      name         = "AWS-EW1-SaaS-C1-Spoke-GW"
      size         = "t3.small"
      active_mesh  = true
      single_az_ha = true
    }
    customer2 = {
      customer     = "customer2"
      name         = "AWS-EW1-SaaS-C2-Spoke-GW"
      size         = "t3.small"
      active_mesh  = true
      single_az_ha = true
    }
  }
}

### Customer S2C gateways.
variable "s2c_gateways" {
  default = {
    customer1 = {
      customer = "customer1"
      name     = "AWS-EW1-SaaS-C1-S2C-GW"
      size     = "t3.small"
    }
    customer2 = {
      customer = "customer2"
      name     = "AWS-EW1-SaaS-C2-S2C-GW"
      size     = "t3.small"
    }
  }
}

### Test EC2 instances.
variable "test_ec2_instances" {
  default = {
    saas_services_vm = {
      name                        = "SaaS-Shared-Services-VM"
      vpc                         = "saas_services"
      ami                         = "ami-0b4b2d87bdd32212a"
      size                        = "t2.micro"
      key                         = "nicolas"
      associate_public_ip_address = true
    }
    customer1_app_vm = {
      name                        = "Customer1-App-VM"
      vpc                         = "customer1"
      ami                         = "ami-0b4b2d87bdd32212a"
      size                        = "t2.micro"
      key                         = "nicolas"
      associate_public_ip_address = true
    }
    customer2_app_vm = {
      name                        = "Customer2-App-VM"
      vpc                         = "customer2"
      ami                         = "ami-0b4b2d87bdd32212a"
      size                        = "t2.micro"
      key                         = "nicolas"
      associate_public_ip_address = true
    }
  }
}
