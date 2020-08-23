provider "aviatrix" {
  # Make sure to keep the version up to date with the controller version.
  # https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/guides/release-compatibility.
  version = "~> 2.15.1"
}

resource "aviatrix_vpc" "aws_transit_vpcs" {
  for_each = var.aws_transit_vpcs

  cloud_type           = 1 # AWS
  account_name         = var.aws_account_name
  region               = var.aws_region
  name                 = each.value.name
  cidr                 = each.value.cidr
  aviatrix_transit_vpc = true
  aviatrix_firenet_vpc = each.value.is_firenet
}

resource "aviatrix_vpc" "aws_spoke_vpcs" {
  for_each = var.aws_spoke_vpcs

  cloud_type           = 1 # AWS
  account_name         = var.aws_account_name
  region               = var.aws_region
  name                 = each.value.name
  cidr                 = each.value.cidr
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
}

### Aviatrix Transit gateway.
resource "aviatrix_transit_gateway" "aws_transit_gw" {
  cloud_type         = 1
  account_name       = var.aws_account_name
  gw_name            = var.aws_transit_gateway.name
  vpc_id             = aviatrix_vpc.aws_transit_vpcs[var.aws_transit_gateway.vpc].vpc_id
  vpc_reg            = var.aws_region
  gw_size            = var.aws_transit_gateway.size
  connected_transit  = true
  enable_active_mesh = var.aws_transit_gateway.active_mesh
  single_az_ha       = var.aws_transit_gateway.single_az_ha
  # The Transit VPC has been created by the controller. It always creates
  # 4 private subnets (north + south in 2 AZs) and the public subnet
  # Public-gateway-and-firewall-mgmt that we use for Transit GW is always the
  # 5th one.
  subnet = aviatrix_vpc.aws_transit_vpcs[var.aws_transit_gateway.vpc].subnets[4]["cidr"]
}

data "aws_availability_zones" "az_available" {
}

### Aviatrix Spoke gateways.
resource "aviatrix_spoke_gateway" "aws_spoke_gws" {
  for_each = var.aws_spoke_gateways

  cloud_type         = 1
  account_name       = var.aws_account_name
  gw_name            = each.value.name
  vpc_id             = aviatrix_vpc.aws_spoke_vpcs[each.value.vpc].vpc_id
  vpc_reg            = var.aws_region
  gw_size            = each.value.size
  enable_active_mesh = each.value.active_mesh
  single_az_ha       = each.value.single_az_ha
  # The Spoke VPC has been created by the controller. It creates X private subnets and X public subnets where X
  # is the number of AZs in the region.  We use the first public subnet.  Therefore we index with the number
  # of AZs in the region to get to the first public subnet.
  subnet     = aviatrix_vpc.aws_spoke_vpcs[each.value.vpc].subnets[length(data.aws_availability_zones.az_available.names)]["cidr"]
  transit_gw = var.aws_transit_gateway.name
  depends_on = [aviatrix_transit_gateway.aws_transit_gw]
}
