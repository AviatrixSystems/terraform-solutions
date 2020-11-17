# From aws configure.
variable "aws_profile" { default = "default" }

variable "account_name" { default = "aws-dev" }
variable "region" { default = "us-east-2" }

### AWS = 1, GCP = 4, Azure = 8, OCI = 16.
variable "cloud_type" { default = 1 }

### VPCs.
variable "vpcs" {
  default = {
    s2c_4 = {
      name       = "AWS-UE2-S2C-4-VPC"
      cidr       = "10.7.4.0/24"
      is_transit = false
      is_firenet = false
    },
    s2c_5 = {
      name       = "AWS-UE2-S2C-5-VPC"
      cidr       = "10.7.5.0/24"
      is_transit = false
      is_firenet = false
    }
  }
}

variable "transit_gateway" {
  default = "AWS-UE2-Transit-GW"
}

### Customer Spoke gateways.
variable "spoke_gateways" {
  default = {
    spoke4 = {
      vpc          = "s2c_4"
      name         = "AWS-UE2-Spoke-4-GW"
      size         = "t3.small"
      active_mesh  = true
      single_az_ha = true
      # VPC CIDR and virtual on-prem subnet
      customized_spoke_adv_vpc_cidr = "10.7.4.0/24,10.134.0.0/24"
      domain                        = "Prod-Domain"
    },
    spoke5 = {
      vpc          = "s2c_5"
      name         = "AWS-UE2-Spoke-5-GW"
      size         = "t3.small"
      active_mesh  = true
      single_az_ha = true
      # VPC CIDR and virtual on-prem subnet
      customized_spoke_adv_vpc_cidr = "10.7.5.0/24,10.135.0.0/24"
      domain                        = "Prod-Domain"
    }
  }
}

### Customer S2C connections.
variable "s2c_connections" {
  default = {
    customer4 = {
      name = "AWS-UE2-C4-Spoke-S2C"
      # Element from vpcs variable.
      vpc = "s2c_4"
      # Element from spoke_gateways variable.
      avx_spoke_gw = "spoke4"
      # Public IP of on-prem router.
      remote_gw_ip = "50.18.221.180"
      remote_cidr  = "10.34.0.0/24"
      local_cidr   = "10.1.0.0/16,10.7.4.0/24"
      psk          = ""
    },
    customer5 = {
      name = "AWS-UE2-C5-Spoke-S2C"
      # Element from vpcs variable.
      vpc = "s2c_5"
      # Element from spoke_gateways variable.
      avx_spoke_gw = "spoke5"
      # Public IP of on-prem router.
      remote_gw_ip = "13.57.46.250"
      remote_cidr  = "10.34.0.0/24"
      local_cidr   = "10.1.0.0/16,10.7.5.0/24"
      psk          = ""
    }
  }
}

### Customized SNAT rules for each Spoke gateway.
variable "spoke_customized_snat_rules" {
  default = {
    spoke4 = {
      rule1 = {
        src_cidr   = "10.34.0.0/24" # On-prem
        dst_cidr   = "10.1.0.0/16"  # Cloud shared services
        protocol   = "all"
        interface  = "eth0"
        connection = "AWS-UE2-Transit-GW" # Post-routing, so outgoing connection
      }
    },
    spoke5 = {
      rule1 = {
        src_cidr   = "10.34.0.0/24" # On-prem
        dst_cidr   = "10.1.0.0/16"  # Cloud shared services
        protocol   = "all"
        interface  = "eth0"
        connection = "AWS-UE2-Transit-GW" # Post-routing, so outgoing connection
      }
    }

  }
}

### Customized DNAT rules for each Spoke gateway.
variable "spoke_customized_dnat_rules" {
  default = {
    spoke4 = {
      rule1 = {
        src_cidr   = "10.1.0.0/16"    # Cloud shared services 
        dst_cidr   = "10.134.0.42/32" # Virtual IP of on-prem workload
        protocol   = "all"
        interface  = "eth0"
        connection = "AWS-UE2-Transit-GW" # Pre-routing, so incoming connection
        dnat_ip    = "10.34.0.42"         # Real IP of on-prem workload
      }
    },
    spoke5 = {
      rule1 = {
        src_cidr   = "10.1.0.0/16"    # Cloud shared services 
        dst_cidr   = "10.135.0.42/32" # Virtual IP of on-prem workload
        protocol   = "all"
        interface  = "eth0"
        connection = "AWS-UE2-Transit-GW" # Pre-routing, so incoming connection
        dnat_ip    = "10.34.0.42"         # Real IP of on-prem workload
      }
    }
  }
}
