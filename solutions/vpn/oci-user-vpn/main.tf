provider "aviatrix" {
    controller_ip      = var.controller_ip
    username           = var.username
    password           = var.password
}

# Create an Aviatrix OCI Gateway with VPN enabled
resource "aviatrix_gateway" "oci_vpn_gw" {
  cloud_type          = 16
  account_name        = var.oci_account_name
  gw_name             = var.vpn_gw_name
  vpc_id              = var.oci_vcn_name
  vpc_reg             = var.oci_region
  gw_size             = var.gw_size
  subnet              = var.vcn_public_subnet_cidr
  vpn_access          = true
  vpn_cidr            = "192.168.43.0/24"
  max_vpn_conn        = "25"
  
}

# Create VPN Users and attach them to OCI VPN Gateway
resource "aviatrix_vpn_user" "oci_vpn_users" {
  for_each           = var.vpn_users
  vpc_id             = aviatrix_gateway.oci_vpn_gw.vpc_id
  gw_name            = aviatrix_gateway.oci_vpn_gw.gw_name
  user_name          = each.value.user_name
  user_email         = each.value.user_email
}