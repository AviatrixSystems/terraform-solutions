variable "aws_account_name" { default = "aws-dev" }
variable "aws_region" { default = "eu-west-1" }

variable "azure_account_name" { default = "azure-network" }
variable "azure_region" { default = "West Europe" }

### VPCs.
variable "aws_vpcs" {
  default = {
    aws_transit_vpc = {
      name       = "AWS-EW1-Transit-VPC"
      cidr       = "10.60.0.0/16"
      is_transit = true
      is_firenet = false
    }
    aws_spoke1_vpc = {
      name       = "AWS-EW1-Spoke1-VPC"
      cidr       = "10.61.0.0/16"
      is_transit = false
      is_firenet = false
    }
    aws_spoke2_vpc = {
      name       = "AWS-EW1-Spoke2-VPC"
      cidr       = "10.62.0.0/16"
      is_transit = false
      is_firenet = false
    }
  }
}

variable "azure_vnets" {
  default = {
    azure_transit_vnet = {
      name       = "AZ-WE-Transit-VNet"
      cidr       = "10.100.0.0/16"
      is_transit = false  # Not a typo, is_transit = true only applies to AWS.
      is_firenet = false
    }
    azure_spoke1_vnet = {
      name       = "AZ-WE-Spoke1-VNet"
      cidr       = "10.101.0.0/16"
      is_transit = false
      is_firenet = false
    }
    azure_spoke2_vnet = {
      name       = "AZ-WE-Spoke2-VNet"
      cidr       = "10.102.0.0/16"
      is_transit = false
      is_firenet = false
    }
  }
}

### AWS Aviatrix Transit gateway.
variable "aws_transit_gateway" {
  default = {
    name         = "AWS-EW1-Transit-GW"
    size         = "t3.small"
    active_mesh  = true
    single_az_ha = true
    vpc          = "aws_transit_vpc"
    subnet       = "10.60.0.80/28"
  }
}

### AWS Aviatrix Spoke1 gateway.
variable "aws_spoke1_gateway" {
  default = {
    name         = "AWS-EW1-Spoke1-GW"
    size         = "t3.small"
    active_mesh  = true
    single_az_ha = true
    vpc          = "aws_spoke1_vpc"
    subnet       = "10.61.64.0/20"
  }
}

### AWS Aviatrix Spoke2 gateway.
variable "aws_spoke2_gateway" {
  default = {
    name         = "AWS-EW1-Spoke2-GW"
    size         = "t3.small"
    active_mesh  = true
    single_az_ha = true
    vpc          = "aws_spoke2_vpc"
    subnet       = "10.62.64.0/20"
  }
}

### Azure Transit gateway.
variable "azure_transit_gateway" {
  default = {
    name         = "AZ-WE-Transit-GW"
    size         = "Standard_B1ms"
    active_mesh  = true
    single_az_ha = true
    vpc          = "azure_transit_vnet"
    subnet       = "10.100.0.0/20"
  }
}

variable "azure_spoke1_gateway" {
  default = {
    name         = "AZ-WE-Spoke1-GW"
    size         = "Standard_B1ms"
    active_mesh  = true
    single_az_ha = true
    vpc          = "azure_spoke1_vnet"
    subnet       = "10.101.0.0/20"
  }
}

variable "azure_spoke2_gateway" {
  default = {
    name         = "AZ-WE-Spoke2-GW"
    size         = "Standard_B1ms"
    active_mesh  = true
    single_az_ha = true
    vpc          = "azure_spoke2_vnet"
    subnet       = "10.102.0.0/20"
  }
}

### Test EC2 instances.
variable "test_ec2_instances" {
  default = {
    aws_spoke1_vm = {
      name                        = "Spoke1-VM"
      vpc                         = "aws_spoke1_vpc"
      ami                         = "ami-0b4b2d87bdd32212a"
      size                        = "t2.micro"
      key                         = "nicolas"
      private_ip                  = "10.61.64.4"
      associate_public_ip_address = true
    }
    aws_spoke2_vm = {
      name                        = "Spoke2-VM"
      vpc                         = "aws_spoke2_vpc"
      ami                         = "ami-0b4b2d87bdd32212a"
      size                        = "t2.micro"
      key                         = "nicolas"
      private_ip                  = "10.62.64.4"
      associate_public_ip_address = true
    }
  }
}

### Test Azure VMs.
variable "test_azure_vms" {
  default = {
    azure_spoke1_vm = {
      name                        = "Spoke1-VM"
      rg                          = "Spoke1-VM-RG"
      location                    = "West Europe"
      vpc                         = "aws_spoke1_vpc"
      ami                         = "ami-0b4b2d87bdd32212a"
      size                        = "t2.micro"
      key                         = "nicolas"
      private_ip                  = "10.61.64.4"
      associate_public_ip_address = true
    }
  }
}
