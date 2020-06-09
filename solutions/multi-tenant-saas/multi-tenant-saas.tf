resource "aviatrix_vpc" "vpcs" {
  for_each             = var.vpcs
  cloud_type           = 1
  account_name         = var.account_name
  region               = var.region
  name                 = each.value.name
  cidr                 = each.value.cidr
  aviatrix_transit_vpc = each.value.is_transit
  aviatrix_firenet_vpc = each.value.is_firenet
}

### Launch the Transit gateway in the Transit VPC.
resource "aviatrix_transit_gateway" "transit_gw" {
  cloud_type         = var.cloud_type
  account_name       = var.account_name
  gw_name            = var.transit_gateway.name
  vpc_id             = aviatrix_vpc.vpcs[var.transit_gateway.vpc].vpc_id
  vpc_reg            = var.region
  gw_size            = var.transit_gateway.size
  connected_transit  = true
  enable_active_mesh = var.transit_gateway.active_mesh
  single_az_ha       = var.transit_gateway.single_az_ha
  # subnets[4] is the first public subnet of a Transit VPC, i.e., AZ-a.
  subnet = aviatrix_vpc.vpcs[var.transit_gateway.vpc].subnets[4].cidr
}

### Launch the shared services Spoke gateway.
### Attach it to the Transit gateway.
resource "aviatrix_spoke_gateway" "services_spoke_gw" {
  cloud_type         = var.cloud_type
  account_name       = var.account_name
  gw_name            = var.services_spoke_gateway.name
  vpc_id             = aviatrix_vpc.vpcs[var.services_spoke_gateway.vpc].vpc_id
  vpc_reg            = var.region
  gw_size            = var.services_spoke_gateway.size
  enable_active_mesh = var.services_spoke_gateway.active_mesh
  single_az_ha       = var.services_spoke_gateway.single_az_ha
  # subnets[3] is the first public subnet of a Spoke VPC, i.e., AZ-a.
  subnet     = aviatrix_vpc.vpcs[var.services_spoke_gateway.vpc].subnets[3].cidr
  transit_gw = var.transit_gateway.name
}

### Launch all customer Spoke gateways in their respective VPCs.
### Attach them to the Transit gateway.
resource "aviatrix_spoke_gateway" "customer_spoke_gws" {
  for_each           = var.spoke_gateways
  cloud_type         = var.cloud_type
  account_name       = var.account_name
  gw_name            = each.value.name
  vpc_id             = aviatrix_vpc.vpcs[each.value.customer].vpc_id
  vpc_reg            = var.region
  gw_size            = each.value.size
  enable_active_mesh = each.value.active_mesh
  single_az_ha       = each.value.single_az_ha
  # subnets[3] is the first public subnet of a Spoke VPC, i.e., AZ-a.
  subnet     = aviatrix_vpc.vpcs[each.value.customer].subnets[3].cidr
  transit_gw = var.transit_gateway.name
}

### Launch all customer S2C gateways in their respective VPCs.
resource "aviatrix_gateway" "customer_s2c_gws" {
  for_each     = var.s2c_gateways
  cloud_type   = var.cloud_type
  account_name = var.account_name
  gw_name      = each.value.name
  vpc_id       = aviatrix_vpc.vpcs[each.value.customer].vpc_id
  vpc_reg      = var.region
  gw_size      = each.value.size
  # subnets[3] is the first public subnet of a Spoke VPC, i.e., AZ-a.
  subnet = aviatrix_vpc.vpcs[each.value.customer].subnets[3].cidr
}

