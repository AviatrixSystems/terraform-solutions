provider "aviatrix" {

  username      = var.username
  password      = var.password
  controller_ip = var.controller_ip

  version = "~> 2.13"
}

resource "random_integer" "subnet" {
  min = 1
  max = 250
}

# Create transit vcn in oci
resource "aviatrix_vpc" "transit_vpc_oci" {
  cloud_type           = 16
  account_name         = var.oci_account_name
  region               = var.oci_region
  name                 = "TF-Demo-avx-transit-vcn"
  cidr                 = "10.4.0.0/16"
  #aviatrix_transit_vpc = false
  #aviatrix_firenet_vpc = false
}

# Create azure spoke vnet
resource "aviatrix_vpc" "azure_spoke" {
  cloud_type           = 8
  account_name         = var.azure_account_name
  region               = var.azure_region
  name                 = "TF-Demo-avx-spoke-vnet"
  cidr                 = "10.2.0.0/16"
  aviatrix_firenet_vpc = false
}

# Create oci spoke vcn
resource "aviatrix_vpc" "oci_spoke" {
  cloud_type           = 16
  account_name         = var.oci_account_name
  region               = var.oci_region
  name                 = "TF-Demo-avx-spoke-vcn"
  cidr                 = "10.3.0.0/16"
  aviatrix_firenet_vpc = false
}

# Create an Aviatrix Oracle Transit Network Gateway (Hub)
resource "aviatrix_transit_gateway" "transit_gateway_oci" {
  cloud_type        = 16
  account_name      = var.oci_account_name
  gw_name           = "TF-Demo-OCI-transit-gw"
  vpc_id            = "TF-Demo-avx-transit-vcn"
  vpc_reg           = var.oci_region
  gw_size           = "VM.Standard2.2"
  subnet            = aviatrix_vpc.transit_vpc_oci.subnets[0].cidr
  connected_transit = true
}

# Create an Aviatrix Azure Spoke Gateway (Spoke)
resource "aviatrix_spoke_gateway" "spoke_gateway_azure" {
  cloud_type   = 8
  account_name = var.azure_account_name
  gw_name      = "TF-Demo-Azure-spoke-gw1"
  transit_gw   = aviatrix_transit_gateway.transit_gateway_oci.gw_name
  vpc_id       = aviatrix_vpc.azure_spoke.vpc_id
  vpc_reg      = var.azure_region
  gw_size      = "Standard_B1s"
  subnet       = aviatrix_vpc.azure_spoke.subnets[0].cidr 
  depends_on   = [aviatrix_transit_gateway.transit_gateway_oci]
}


# Create an Aviatrix Oracle Spoke Gateway (Spoke)
resource "aviatrix_spoke_gateway" "spoke_gateway_oracle" {
  cloud_type   = 16
  account_name = var.oci_account_name
  gw_name      = "TF-Demo-OCI-spoke-gw1"
  transit_gw   = aviatrix_transit_gateway.transit_gateway_oci.gw_name
  vpc_id       = aviatrix_vpc.oci_spoke.name
  vpc_reg      = var.oci_region
  gw_size      = "VM.Standard2.2"
  subnet       = aviatrix_vpc.oci_spoke.subnets[0].cidr
  depends_on   = [aviatrix_transit_gateway.transit_gateway_oci]
}

