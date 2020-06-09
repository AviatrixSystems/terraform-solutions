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

### On every S2C gateway, create S2C connection to VGW.
resource "aviatrix_site2cloud" "s2c_connections" {
  for_each = var.s2c_connections

  vpc_id                     = aviatrix_vpc.vpcs[each.key].vpc_id
  connection_name            = each.value.name
  connection_type            = "unmapped"
  remote_gateway_type        = "aws"
  tunnel_type                = "udp"
  primary_cloud_gateway_name = var.s2c_gateways[each.key].name
  # AWS VGW Site-to-Site
  remote_gateway_ip          = aws_vpn_connection.s2s_vpn_connections[each.key].tunnel1_address
  remote_subnet_cidr         = each.value.remote_cidr
  local_subnet_cidr          = each.value.local_cidr
  ha_enabled                 = false
  private_route_encryption   = null
  custom_algorithms          = true
  phase_1_authentication     = "SHA-1"
  phase_2_authentication     = "HMAC-SHA-1"
  phase_1_dh_groups          = "2"
  phase_2_dh_groups          = "2"
  phase_1_encryption         = "AES-128-CBC"
  phase_2_encryption         = "AES-128-CBC"
  pre_shared_key             = aws_vpn_connection.s2s_vpn_connections[each.key].tunnel1_preshared_key
  enable_dead_peer_detection = true
}

### Get the route table ID of the S2C gateways.
data "aws_route_table" "s2c_route_tables" {
  for_each = var.s2c_gateways

  # Get the route table from the subnet ID of the gateway
  subnet_id = aviatrix_vpc.vpcs[each.key].subnets[3].subnet_id
}

### On every S2C gateway, configure customized SNAT.
resource "aviatrix_gateway_snat" "s2c_customized_snat" {
  for_each = var.s2c_customized_snat_rules

  gw_name   = var.s2c_gateways[each.key].name
  snat_mode = "customized_snat"
  snat_policy {
    src_cidr   = each.value.src_cidr
    dst_cidr   = each.value.dst_cidr
    protocol   = each.value.protocol
    interface  = "eth0"
    connection = "None"
    # Private IP of the S2C GW.
    snat_ips = aviatrix_gateway.customer_s2c_gws[each.key].private_ip
    # Important to exclude the route table. Upon Spoke GW attachment,
    # the controller has programmed the shared services VPC CIDR to
    # point to the Spoke GW. Without exclude route table, this would
    # be overriden by dst_cidr.
    exclude_rtb = data.aws_route_table.s2c_route_tables[each.key].id
  }
}

