resource "aviatrix_vpc" "aws_vpcs" {
  for_each = var.aws_vpcs

  cloud_type           = 1 # AWS
  account_name         = var.aws_account_name
  region               = var.aws_region
  name                 = each.value.name
  cidr                 = each.value.cidr
  aviatrix_transit_vpc = each.value.is_transit
  aviatrix_firenet_vpc = each.value.is_firenet
}

### Launch the Aviatrix Transit gateway in the AWS Transit VPC.
resource "aviatrix_transit_gateway" "aws_transit_gw" {
  cloud_type         = 1
  account_name       = var.aws_account_name
  gw_name            = var.aws_transit_gateway.name
  vpc_id             = aviatrix_vpc.aws_vpcs[var.aws_transit_gateway.vpc].vpc_id
  vpc_reg            = var.aws_region
  gw_size            = var.aws_transit_gateway.size
  connected_transit  = true
  enable_active_mesh = var.aws_transit_gateway.active_mesh
  single_az_ha       = var.aws_transit_gateway.single_az_ha
  subnet             = var.aws_transit_gateway.subnet
}

### Launch the AWS Spoke1 gateway.
### Attach it to the Transit gateway.
resource "aviatrix_spoke_gateway" "aws_spoke1_gw" {
  cloud_type         = 1
  account_name       = var.aws_account_name
  gw_name            = var.aws_spoke1_gateway.name
  vpc_id             = aviatrix_vpc.aws_vpcs[var.aws_spoke1_gateway.vpc].vpc_id
  vpc_reg            = var.aws_region
  gw_size            = var.aws_spoke1_gateway.size
  enable_active_mesh = var.aws_spoke1_gateway.active_mesh
  single_az_ha       = var.aws_spoke1_gateway.single_az_ha
  subnet             = var.aws_spoke1_gateway.subnet
  transit_gw         = var.aws_transit_gateway.name
}

### Launch the AWS Spoke2 gateway.
### Attach it to the Transit gateway.
resource "aviatrix_spoke_gateway" "aws_spoke2_gw" {
  cloud_type         = 1
  account_name       = var.aws_account_name
  gw_name            = var.aws_spoke2_gateway.name
  vpc_id             = aviatrix_vpc.aws_vpcs[var.aws_spoke2_gateway.vpc].vpc_id
  vpc_reg            = var.aws_region
  gw_size            = var.aws_spoke2_gateway.size
  enable_active_mesh = var.aws_spoke2_gateway.active_mesh
  single_az_ha       = var.aws_spoke2_gateway.single_az_ha
  subnet             = var.aws_spoke2_gateway.subnet
  transit_gw         = var.aws_transit_gateway.name
}
