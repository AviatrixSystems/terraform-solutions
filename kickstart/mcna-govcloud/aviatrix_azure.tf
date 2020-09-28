### Onboard Azure account.
resource "aviatrix_account" "azure_account" {
  account_name        = var.azure_account_name
  cloud_type          = 8 # Azure
  arm_subscription_id = var.azure_subscription_id
  arm_directory_id    = var.azure_directory_id
  arm_application_id  = var.azure_application_id
  arm_application_key = var.azure_application_key
}

resource "aviatrix_vpc" "azure_vnets" {
  for_each = var.azure_vnets

  cloud_type           = 8 # Azure
  account_name         = var.azure_account_name
  region               = var.azure_region
  name                 = each.value.name
  cidr                 = each.value.cidr
  aviatrix_transit_vpc = each.value.is_transit
  aviatrix_firenet_vpc = each.value.is_firenet
  depends_on           = [aviatrix_account.azure_account]
}

### Azure Transit gateway.
resource "aviatrix_transit_gateway" "azure_transit_gw" {
  cloud_type         = 8
  account_name       = var.azure_account_name
  gw_name            = var.azure_transit_gateway.name
  vpc_id             = aviatrix_vpc.azure_vnets[var.azure_transit_gateway.vpc].vpc_id
  vpc_reg            = var.azure_region
  gw_size            = var.azure_transit_gateway.size
  connected_transit  = true
  enable_active_mesh = var.azure_transit_gateway.active_mesh
  single_az_ha       = var.azure_transit_gateway.single_az_ha
  # The first subnet is always a public subnet for gateways.
  subnet = aviatrix_vpc.azure_vnets[var.azure_transit_gateway.vpc].subnets[0].cidr
}

### Azure Spoke gateways and attachment to Azure Transit gateway.
resource "aviatrix_spoke_gateway" "azure_spoke_gws" {
  for_each = var.azure_spoke_gateways

  cloud_type         = 8
  account_name       = var.azure_account_name
  gw_name            = each.value.name
  vpc_id             = aviatrix_vpc.azure_vnets[each.value.vpc].vpc_id
  vpc_reg            = var.azure_region
  gw_size            = each.value.size
  enable_active_mesh = each.value.active_mesh
  single_az_ha       = each.value.single_az_ha
  # The first subnet is always a public subnet for gateways.
  subnet     = aviatrix_vpc.azure_vnets[each.value.vpc].subnets[0].cidr
  transit_gw = var.azure_transit_gateway.name
  depends_on = [aviatrix_transit_gateway.azure_transit_gw]
}
