provider "aviatrix" {

  username      = var.username
  password      = var.password
  controller_ip = var.controller_ip

  version = "~> 2.13"
}

provider "aws" {
  region = "us-east-2"
}

resource "random_integer" "subnet" {
  min = 1
  max = 250
}

data "aws_availability_zones" "az_available" {}

resource "aviatrix_vpc" "transit_firenet" {
  cloud_type           = 1
  account_name         = var.account_name
  region               = var.region
  name                 = "avx-firenet-vpc-${var.region}"
  cidr                 = "10.1.0.0/16"
  #cidr                 = cidrsubnet("10.0.0.0/8", 8, random_integer.subnet.result)
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = true
}

resource "aviatrix_vpc" "avx_spoke_vpc" {
  count                = var.vpc_count
  cloud_type           = 1
  account_name         = var.account_name
  region               = var.region
  name                 = "${var.region}-avx-spoke-vpc-${count.index + 1}"
  cidr                 = cidrsubnet("10.0.1.0/8", 8, random_integer.subnet.result + count.index)
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
}

resource "aviatrix_transit_gateway" "transit_firenet_gw" {
  cloud_type                    = 1
  vpc_reg                       = var.region
  vpc_id                        = aviatrix_vpc.transit_firenet.vpc_id
  account_name                  = aviatrix_vpc.transit_firenet.account_name
  gw_name                       = var.avx_transit_gw
  ha_gw_size                    = var.avx_gw_size
  gw_size                       = var.avx_gw_size
  subnet                        = var.hpe ? cidrsubnet(aviatrix_vpc.transit_firenet.cidr, 10, 4) : aviatrix_vpc.transit_firenet.subnets[0].cidr
  ha_subnet                     = var.hpe ? cidrsubnet(aviatrix_vpc.transit_firenet.cidr, 10, 8) : aviatrix_vpc.transit_firenet.subnets[3].cidr 
  insane_mode_az                = var.hpe ? data.aws_subnet.gw_az.availability_zone : null
  ha_insane_mode_az             = var.hpe ? data.aws_subnet.hagw_az.availability_zone : null
  enable_active_mesh            = true
  enable_hybrid_connection      = true
  enable_transit_firenet        = true
  connected_transit             = true
  depends_on = [aviatrix_vpc.transit_firenet]
}


resource "aviatrix_spoke_gateway" "avtx_spoke_gw" {
  count              = var.vpc_count
  cloud_type         = 1
  account_name       = var.account_name
  gw_name            = "avx-firenet-spoke-gw-${count.index}"
  vpc_id             = aviatrix_vpc.avx_spoke_vpc[count.index].vpc_id
  vpc_reg            = var.region
  gw_size            = "t2.micro"
  subnet             = aviatrix_vpc.avx_spoke_vpc[count.index].subnets[length(data.aws_availability_zones.az_available.names)]["cidr"]
  transit_gw         = var.avx_transit_gw
  enable_active_mesh = true
  depends_on = [aviatrix_transit_gateway.transit_firenet_gw]
}


# Create an Aviatrix Firewall Instance in az1
resource "aviatrix_firewall_instance" "firewall_instance_az1" {
  vpc_id                        = aviatrix_vpc.transit_firenet.vpc_id
  firenet_gw_name               = aviatrix_transit_gateway.transit_firenet_gw.gw_name
  firewall_name                 = "avx-fw-az1"
  firewall_image                = var.fw_image
  firewall_size                 = var.firewall_size
  management_subnet             = aviatrix_vpc.transit_firenet.subnets[0].cidr
  egress_subnet                 = aviatrix_vpc.transit_firenet.subnets[1].cidr
  key_name                      = "avtx-dev"
  depends_on = [aviatrix_spoke_gateway.avtx_spoke_gw]
}

# Create an Aviatrix Firewall Instance in az2
resource "aviatrix_firewall_instance" "firewall_instance_az2" {
  vpc_id                        = aviatrix_vpc.transit_firenet.vpc_id
  firenet_gw_name               = "${aviatrix_transit_gateway.transit_firenet_gw.gw_name}-hagw" 
  firewall_name                 = "avx-fw-az2"
  firewall_image                = var.fw_image
  firewall_size                 = var.firewall_size
  management_subnet             = aviatrix_vpc.transit_firenet.subnets[2].cidr
  egress_subnet                 = aviatrix_vpc.transit_firenet.subnets[3].cidr
  key_name                      = "avtx-dev"
  depends_on = [aviatrix_spoke_gateway.avtx_spoke_gw]
}

resource "aviatrix_firenet" "firewall_net" {
  vpc_id             = aviatrix_vpc.transit_firenet.vpc_id
  inspection_enabled = true
  egress_enabled     = true

  firewall_instance_association {
    firenet_gw_name      = aviatrix_transit_gateway.transit_firenet_gw.gw_name
    vendor_type          = "Generic"
    instance_id          = aviatrix_firewall_instance.firewall_instance_az1.instance_id
    firewall_name        = aviatrix_firewall_instance.firewall_instance_az1.firewall_name
    attached             = true
    lan_interface        = aviatrix_firewall_instance.firewall_instance_az1.lan_interface
    management_interface = aviatrix_firewall_instance.firewall_instance_az1.management_interface
    egress_interface     = aviatrix_firewall_instance.firewall_instance_az1.egress_interface
  }

  firewall_instance_association {
    firenet_gw_name      = "${aviatrix_transit_gateway.transit_firenet_gw.gw_name}-hagw"
    vendor_type          = "Generic"
    instance_id          = aviatrix_firewall_instance.firewall_instance_az2.instance_id
    firewall_name        = aviatrix_firewall_instance.firewall_instance_az2.firewall_name
    attached             = true
    lan_interface        = aviatrix_firewall_instance.firewall_instance_az2.lan_interface
    management_interface = aviatrix_firewall_instance.firewall_instance_az2.management_interface
    egress_interface     = aviatrix_firewall_instance.firewall_instance_az2.egress_interface
  }
}

# Create an Aviatrix Transit FireNet Policy
resource "aviatrix_transit_firenet_policy" "transit_firenet_policy1" {
  transit_firenet_gateway_name = aviatrix_transit_gateway.transit_firenet_gw.gw_name
  inspected_resource_name      = "SPOKE:avx-firenet-spoke-gw-0"
  depends_on = [aviatrix_firenet.firewall_net]
}

resource "aviatrix_transit_firenet_policy" "transit_firenet_policy2" {
  transit_firenet_gateway_name = aviatrix_transit_gateway.transit_firenet_gw.gw_name
  inspected_resource_name      = "SPOKE:avx-firenet-spoke-gw-1"
  depends_on = [aviatrix_firenet.firewall_net]
}


data "aws_subnet" "gw_az" {
  id = aviatrix_vpc.transit_firenet.subnets[0].subnet_id
}

data "aws_subnet" "hagw_az" {
  id = aviatrix_vpc.transit_firenet.subnets[3].subnet_id
}
