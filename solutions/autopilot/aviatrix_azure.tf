resource "aviatrix_vpc" "azure_vnets" {
  for_each = var.azure_vnets

  cloud_type           = 8 # Azure
  account_name         = var.azure_account_name
  region               = var.azure_region
  name                 = each.value.name
  cidr                 = each.value.cidr
  aviatrix_transit_vpc = each.value.is_transit
  aviatrix_firenet_vpc = each.value.is_firenet
}

# ### Launch the Aviatrix Transit gateway in the Azure Transit VNet.
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
  subnet             = var.azure_transit_gateway.subnet
}

### Launch the Azure Spoke1 gateway.
### Attach it to the Transit gateway.
resource "aviatrix_spoke_gateway" "azure_spoke1_gw" {
  cloud_type         = 8
  account_name       = var.azure_account_name
  gw_name            = var.azure_spoke1_gateway.name
  vpc_id             = aviatrix_vpc.azure_vnets[var.azure_spoke1_gateway.vpc].vpc_id
  vpc_reg            = var.azure_region
  gw_size            = var.azure_spoke1_gateway.size
  enable_active_mesh = var.azure_spoke1_gateway.active_mesh
  single_az_ha       = var.azure_spoke1_gateway.single_az_ha
  subnet             = var.azure_spoke1_gateway.subnet
  transit_gw         = var.azure_transit_gateway.name
}

### Launch the Azure Spoke2 gateway.
### Attach it to the Transit gateway.
resource "aviatrix_spoke_gateway" "azure_spoke2_gw" {
  cloud_type         = 8
  account_name       = var.azure_account_name
  gw_name            = var.azure_spoke2_gateway.name
  vpc_id             = aviatrix_vpc.azure_vnets[var.azure_spoke2_gateway.vpc].vpc_id
  vpc_reg            = var.azure_region
  gw_size            = var.azure_spoke2_gateway.size
  enable_active_mesh = var.azure_spoke2_gateway.active_mesh
  single_az_ha       = var.azure_spoke2_gateway.single_az_ha
  subnet             = var.azure_spoke2_gateway.subnet
  transit_gw         = var.azure_transit_gateway.name
}
