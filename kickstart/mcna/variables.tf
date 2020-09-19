variable "aws_profile" { default = "default" }
variable "aws_account_name" { default = "aws-account" }
variable "aws_region" { default = "us-east-2" }
# Only needed if you want to launch test EC2 instances.
variable "aws_ec2_key_name" { default = "nicolas" }

variable "azure_account_name" { default = "azure-network" }
variable "azure_region" { default = "East US" }
variable "azure_subscription_id" { default = "" }
variable "azure_directory_id" { default = "" }
variable "azure_application_id" { default = "" }
variable "azure_application_key" { default = "" }

### VPCs.
variable "aws_transit_vpcs" {
  default = {
    aws_transit_vpc = {
      name       = "AWS-UE2-Transit-VPC"
      cidr       = "10.60.0.0/16"
      is_firenet = false
    }
  }
}

variable "aws_spoke_vpcs" {
  default = {
    aws_spoke1_vpc = {
      name = "AWS-UE2-Spoke1-VPC"
      cidr = "10.61.0.0/16"
    }
    aws_spoke2_vpc = {
      name = "AWS-UE2-Spoke2-VPC"
      cidr = "10.62.0.0/16"
    }
  }
}

### AWS Aviatrix Transit gateway.
variable "aws_transit_gateway" {
  default = {
    name         = "AWS-UE2-Transit-GW"
    size         = "t3.small"
    active_mesh  = true
    single_az_ha = true
    vpc          = "aws_transit_vpc"
  }
}

variable "aws_spoke_gateways" {
  default = {
    spoke1 = {
      name         = "AWS-UE2-Spoke1-GW"
      size         = "t3.small"
      active_mesh  = true
      single_az_ha = true
      vpc          = "aws_spoke1_vpc"
    },
    spoke2 = {
      name         = "AWS-UE2-Spoke2-GW"
      size         = "t3.small"
      active_mesh  = true
      single_az_ha = true
      vpc          = "aws_spoke2_vpc"
    }
  }
}

### Test EC2 instances.
variable "test_ec2_instances" {
  default = {
    spoke1_vm = {
      name                        = "Spoke1-VM"
      vpc                         = "aws_spoke1_vpc"
      size                        = "t2.micro"
      associate_public_ip_address = true
    }
    spoke2_vm = {
      name                        = "Spoke2-VM"
      vpc                         = "aws_spoke2_vpc"
      size                        = "t2.micro"
      associate_public_ip_address = true
    }
  }
}

variable "azure_vnets" {
  default = {
    azure_transit_vnet = {
      name       = "AZ-EU-Transit-VNet"
      cidr       = "10.100.0.0/16"
      is_transit = false # Not a typo, is_transit = true only applies to AWS.
      is_firenet = false
    }
    azure_spoke1_vnet = {
      name       = "AZ-EU-Spoke1-VNet"
      cidr       = "10.101.0.0/16"
      is_transit = false
      is_firenet = false
    }
    azure_spoke2_vnet = {
      name       = "AZ-EU-Spoke2-VNet"
      cidr       = "10.102.0.0/16"
      is_transit = false
      is_firenet = false
    }
  }
}

### Azure Transit gateway.
variable "azure_transit_gateway" {
  default = {
    name         = "AZ-EU-Transit-GW"
    size         = "Standard_B1ms"
    active_mesh  = true
    single_az_ha = true
    vpc          = "azure_transit_vnet"
    subnet       = "10.100.0.0/20"
  }
}

variable "azure_spoke_gateways" {
  default = {
    spoke1 = {
      name         = "AZ-EU-Spoke1-GW"
      size         = "Standard_B1ms"
      active_mesh  = true
      single_az_ha = true
      vpc          = "azure_spoke1_vnet"
    },
    spoke2 = {
      name         = "AZ-EU-Spoke2-GW"
      size         = "Standard_B1ms"
      active_mesh  = true
      single_az_ha = true
      vpc          = "azure_spoke2_vnet"
    }
  }
}
