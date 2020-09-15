variable "gcp_account_name" { default = "gcp-dev" }

### VPCs.
variable "gcp_vpcs" {
  default = {
    bu_transit = {
      name        = "gcp-bu-transit-vpc"
      subnet_name = "gcp-bu-transit-subnet"
      subnet_cidr = "10.160.0.0/24"
      region      = "us-west2"
    },
    bu1_app = {
      name        = "gcp-bu1-app-shared-vpc"
      subnet_name = "gcp-bu1-app-spoke-subnet"
      subnet_cidr = "10.160.2.0/24"
      region      = "us-west2"
    },
    bu2_app = {
      name        = "gcp-bu2-app-shared-vpc"
      subnet_name = "gcp-bu2-app-spoke-subnet"
      subnet_cidr = "10.160.4.0/24"
      region      = "us-west2"
    },
    central_it_transit = {
      name        = "gcp-central-it-transit-vpc"
      subnet_name = "gcp-central-it-transit-subnet"
      subnet_cidr = "10.160.1.0/24"
      region      = "us-west3"
    },
    db = {
      name        = "gcp-db-vpc"
      subnet_name = "gcp-db-spoke-subnet"
      subnet_cidr = "10.160.6.0/24"
      region      = "us-west3"
    }
  }
}

### GCP Transit gateways.
variable "gcp_bu_transit_gateway" {
  default = {
    name         = "gcp-bu-transit-gw"
    size         = "n1-standard-1"
    active_mesh  = true
    single_az_ha = true
    vpc          = "bu_transit"
    zone         = "us-west2-a"
    asn          = "65160"
  }
}

variable "gcp_central_it_transit_gateway" {
  default = {
    name         = "gcp-central-it-transit-gw"
    size         = "n1-standard-1"
    active_mesh  = true
    single_az_ha = true
    vpc          = "central_it_transit"
    zone         = "us-west3-c"
    asn          = "65161"
  }
}

### GCP BU Spoke gateways.
variable "gcp_bu_spoke_gateways" {
  default = {
    bu1 = {
      name                      = "gcp-bu1-app-spoke-gw"
      size                      = "n1-standard-1"
      active_mesh               = true
      single_az_ha              = true
      vpc                       = "bu1_app"
      zone                      = "us-west2-a"
      customized_spoke_vpc_cidr = "10.160.2.0/24,10.160.3.0/24"
      transit_gw                = "gcp-bu-transit-gw"
    },
    bu2 = {
      name                      = "gcp-bu2-app-spoke-gw"
      size                      = "n1-standard-1"
      active_mesh               = true
      single_az_ha              = true
      vpc                       = "bu2_app"
      zone                      = "us-west2-a"
      customized_spoke_vpc_cidr = "10.160.4.0/24,10.160.5.0/24"
      transit_gw                = "gcp-bu-transit-gw"
    }
  }
}

### GCP IT Spoke gateways.
variable "gcp_it_spoke_gateways" {
  default = {
    db = {
      name                      = "gcp-db-spoke-gw"
      size                      = "n1-standard-1"
      active_mesh               = true
      single_az_ha              = true
      vpc                       = "db"
      zone                      = "us-west3-c"
      customized_spoke_vpc_cidr = "10.160.6.0/24,10.160.7.0/24"
      transit_gw                = "gcp-central-it-transit-gw"
    }
  }
}

### Central-IT Transit gateway S2C.
variable "central_it_s2c" {
  default = {
    name       = "gcp-central-it-washington-s2c"
    remote_asn = "65051"
    remote_ip  = "54.204.224.4"
  }
}
