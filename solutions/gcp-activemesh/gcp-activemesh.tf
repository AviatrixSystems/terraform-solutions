provider "aviatrix" {
  # Make sure to keep the version up to date with the controller version.
  # https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/guides/release-compatibility.
  version = "~> 2.16.2"
}

resource "aviatrix_vpc" "gcp_vpcs" {
  for_each = var.gcp_vpcs

  cloud_type   = 4 # GCP
  account_name = var.gcp_account_name
  name         = each.value.name

  subnets {
    name   = each.value.subnet_name
    region = each.value.region
    cidr   = each.value.subnet_cidr
  }
}

### GCP Transit gateways.
resource "aviatrix_transit_gateway" "gcp_bu_transit_gateway" {
  cloud_type         = 4
  account_name       = var.gcp_account_name
  gw_name            = var.gcp_bu_transit_gateway.name
  vpc_id             = aviatrix_vpc.gcp_vpcs[var.gcp_bu_transit_gateway.vpc].vpc_id
  vpc_reg            = var.gcp_bu_transit_gateway.zone
  gw_size            = var.gcp_bu_transit_gateway.size
  connected_transit  = true
  enable_active_mesh = var.gcp_bu_transit_gateway.active_mesh
  single_az_ha       = var.gcp_bu_transit_gateway.single_az_ha
  subnet             = var.gcp_vpcs[var.gcp_bu_transit_gateway.vpc].subnet_cidr
  local_as_number    = var.gcp_bu_transit_gateway.asn
}

resource "aviatrix_transit_gateway" "gcp_central_it_transit_gateway" {
  cloud_type         = 4
  account_name       = var.gcp_account_name
  gw_name            = var.gcp_central_it_transit_gateway.name
  vpc_id             = aviatrix_vpc.gcp_vpcs[var.gcp_central_it_transit_gateway.vpc].vpc_id
  vpc_reg            = var.gcp_central_it_transit_gateway.zone
  gw_size            = var.gcp_central_it_transit_gateway.size
  connected_transit  = true
  enable_active_mesh = var.gcp_central_it_transit_gateway.active_mesh
  single_az_ha       = var.gcp_central_it_transit_gateway.single_az_ha
  subnet             = var.gcp_vpcs[var.gcp_central_it_transit_gateway.vpc].subnet_cidr
  local_as_number    = var.gcp_central_it_transit_gateway.asn
}

### Peer the Transit gateways.
resource "aviatrix_transit_gateway_peering" "peering" {
  transit_gateway_name1 = var.gcp_bu_transit_gateway.name
  transit_gateway_name2 = var.gcp_central_it_transit_gateway.name
  depends_on            = [aviatrix_transit_gateway.gcp_bu_transit_gateway, aviatrix_transit_gateway.gcp_central_it_transit_gateway]
}

### GCP BU Spoke gateways.
resource "aviatrix_spoke_gateway" "gcp_bu_spoke_gws" {
  for_each = var.gcp_bu_spoke_gateways

  cloud_type                       = 4
  account_name                     = var.gcp_account_name
  gw_name                          = each.value.name
  vpc_id                           = aviatrix_vpc.gcp_vpcs[each.value.vpc].vpc_id
  vpc_reg                          = each.value.zone
  gw_size                          = each.value.size
  enable_active_mesh               = each.value.active_mesh
  single_az_ha                     = each.value.single_az_ha
  subnet                           = var.gcp_vpcs[each.value.vpc].subnet_cidr
  included_advertised_spoke_routes = each.value.customized_spoke_vpc_cidr
  transit_gw                       = each.value.transit_gw
  depends_on                       = [aviatrix_transit_gateway.gcp_bu_transit_gateway]
}

### GCP IT Spoke gateways.
resource "aviatrix_spoke_gateway" "gcp_it_spoke_gws" {
  for_each = var.gcp_it_spoke_gateways

  cloud_type                       = 4
  account_name                     = var.gcp_account_name
  gw_name                          = each.value.name
  vpc_id                           = aviatrix_vpc.gcp_vpcs[each.value.vpc].vpc_id
  vpc_reg                          = each.value.zone
  gw_size                          = each.value.size
  enable_active_mesh               = each.value.active_mesh
  single_az_ha                     = each.value.single_az_ha
  subnet                           = var.gcp_vpcs[each.value.vpc].subnet_cidr
  included_advertised_spoke_routes = each.value.customized_spoke_vpc_cidr
  transit_gw                       = each.value.transit_gw
  depends_on                       = [aviatrix_transit_gateway.gcp_central_it_transit_gateway]
}

data "aviatrix_vpc" "gcp_it_transit_vpc" {
  name = "gcp-central-it-transit-vpc"
}

### S2C on Central-IT Transit gateway.
resource "aviatrix_transit_external_device_conn" "central_it_s2c" {
  vpc_id            = data.aviatrix_vpc.gcp_it_transit_vpc.vpc_id
  connection_name   = var.central_it_s2c.name
  gw_name           = var.gcp_central_it_transit_gateway.name
  connection_type   = "bgp"
  bgp_local_as_num  = var.gcp_central_it_transit_gateway.asn
  bgp_remote_as_num = var.central_it_s2c.remote_asn
  remote_gateway_ip = var.central_it_s2c.remote_ip
}
