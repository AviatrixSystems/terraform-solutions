provider "aviatrix" {
  # Make sure to keep the version up to date with the controller version.
  # https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/guides/release-compatibility.
  version = "~> 2.17"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.region
}

resource "aviatrix_vpc" "vpcs" {
  for_each = var.vpcs

  cloud_type           = var.cloud_type
  account_name         = var.account_name
  region               = var.region
  name                 = each.value.name
  cidr                 = each.value.cidr
  aviatrix_transit_vpc = each.value.is_transit
  aviatrix_firenet_vpc = each.value.is_firenet
}

data "aws_availability_zones" "az_available" {
}

### Launch all customer Spoke gateways in their respective VPCs.
### Attach them to the Transit gateway.
resource "aviatrix_spoke_gateway" "customer_spoke_gws" {
  for_each           = var.spoke_gateways
  cloud_type         = var.cloud_type
  account_name       = var.account_name
  gw_name            = each.value.name
  vpc_id             = aviatrix_vpc.vpcs[each.value.vpc].vpc_id
  vpc_reg            = var.region
  gw_size            = each.value.size
  enable_active_mesh = each.value.active_mesh
  single_az_ha       = each.value.single_az_ha
  # The Spoke VPC has been created by the controller. It creates X private
  # subnets and X public subnets where X is the number of AZs in the region.
  # We use the first public subnet. Therefore, we index with the number
  # of AZs in the region to get to the first public subnet.
  subnet                           = aviatrix_vpc.vpcs[each.value.vpc].subnets[length(data.aws_availability_zones.az_available.names)]["cidr"]
  transit_gw                       = var.transit_gateway
  included_advertised_spoke_routes = each.value.customized_spoke_adv_vpc_cidr
}

### Associate the Spoke gateway to their segmentation domain.
resource "aviatrix_segmentation_security_domain_association" "domain_associations" {
  for_each             = var.spoke_gateways
  attachment_name      = each.value.name
  transit_gateway_name = var.transit_gateway
  security_domain_name = each.value.domain

  depends_on = [aviatrix_spoke_gateway.customer_spoke_gws]
}

### On every Spoke gateway, create S2C connection to on-prem customer.
resource "aviatrix_site2cloud" "s2c_connections" {
  for_each = var.s2c_connections

  vpc_id              = aviatrix_vpc.vpcs[each.value.vpc].vpc_id
  connection_name     = each.value.name
  connection_type     = "unmapped"
  remote_gateway_type = "generic"
  tunnel_type         = "policy"
  primary_cloud_gateway_name = var.spoke_gateways[each.value.avx_spoke_gw].name
  remote_gateway_ip          = each.value.remote_gw_ip
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
  pre_shared_key             = each.value.psk
  enable_dead_peer_detection = true

  depends_on = [aviatrix_spoke_gateway.customer_spoke_gws]
}

### On every Spoke gateway, configure customized SNAT rules.
### We SNAT on-prem-initiated traffic to the private IP of the GW.
### Cannot nest for_each statements, so need separate resources for each GW.
resource "aviatrix_gateway_snat" "customized_snat_spoke4" {
  gw_name    = var.spoke_gateways["spoke4"].name
  snat_mode  = "customized_snat"
  sync_to_ha = false

  dynamic snat_policy {
    for_each = var.spoke_customized_snat_rules["spoke4"]
    content {
      src_cidr   = snat_policy.value.src_cidr
      dst_cidr   = snat_policy.value.dst_cidr
      protocol   = snat_policy.value.protocol
      connection = snat_policy.value.connection
      # Private IP of the Spoke GW.
      snat_ips = aviatrix_spoke_gateway.customer_spoke_gws["spoke4"].private_ip
    }
  }

  depends_on = [aviatrix_spoke_gateway.customer_spoke_gws]
}

### On every Spoke gateway, configure customized DNAT rules.
### We DNAT cloud-initiated traffic (destined to a virtual IP) to the real
### IP of the on-prem workload.
### Cannot nest for_each statements, so need separate resources for each GW.
resource "aviatrix_gateway_dnat" "customized_dnat_spoke4" {
  gw_name    = var.spoke_gateways["spoke4"].name
  sync_to_ha = false

  dynamic dnat_policy {
    for_each = var.spoke_customized_dnat_rules["spoke4"]
    content {
      src_cidr   = dnat_policy.value.src_cidr
      dst_cidr   = dnat_policy.value.dst_cidr
      protocol   = dnat_policy.value.protocol
      connection = dnat_policy.value.connection
      dnat_ips   = dnat_policy.value.dnat_ip
    }
  }

  lifecycle {
    ignore_changes = [
      dnat_policy
    ]
  }

  depends_on = [aviatrix_spoke_gateway.customer_spoke_gws]
}

### On every Spoke gateway, configure customized SNAT rules.
### We SNAT on-prem-initiated traffic to the private IP of the GW.
### Cannot nest for_each statements, so need separate resources for each GW.
resource "aviatrix_gateway_snat" "customized_snat_spoke5" {
  gw_name    = var.spoke_gateways["spoke5"].name
  snat_mode  = "customized_snat"
  sync_to_ha = false

  dynamic snat_policy {
    for_each = var.spoke_customized_snat_rules["spoke5"]
    content {
      src_cidr   = snat_policy.value.src_cidr
      dst_cidr   = snat_policy.value.dst_cidr
      protocol   = snat_policy.value.protocol
      connection = snat_policy.value.connection
      # Private IP of the Spoke GW.
      snat_ips = aviatrix_spoke_gateway.customer_spoke_gws["spoke5"].private_ip
    }
  }

  depends_on = [aviatrix_spoke_gateway.customer_spoke_gws]
}

### On every Spoke gateway, configure customized DNAT rules.
### We DNAT cloud-initiated traffic (destined to a virtual IP) to the real
### IP of the on-prem workload.
### Cannot nest for_each statements, so need separate resources for each GW.
resource "aviatrix_gateway_dnat" "customized_dnat_spoke5" {
  gw_name    = var.spoke_gateways["spoke5"].name
  sync_to_ha = false

  dynamic dnat_policy {
    for_each = var.spoke_customized_dnat_rules["spoke5"]
    content {
      src_cidr   = dnat_policy.value.src_cidr
      dst_cidr   = dnat_policy.value.dst_cidr
      protocol   = dnat_policy.value.protocol
      connection = dnat_policy.value.connection
      dnat_ips   = dnat_policy.value.dnat_ip
    }
  }

  lifecycle {
    ignore_changes = [
      dnat_policy
    ]
  }

  depends_on = [aviatrix_spoke_gateway.customer_spoke_gws]
}
