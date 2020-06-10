# Replace the values with your own
Aviatrix999#
# Aviatrix Controller
username                = "devops"
password                = "Aviatrix#123"
controller_ip           = "3.135.102.99" # Replace with your Conroller IP
oci_account_name        = "TM-OCI" # Your OCI Access Account name defined in Aviatrix Controller


/*
OCI VPN Details 
This will deploy a VPN gateway into an existing OCI vcn with a public subnet
the region is defaulted to ashburn you can specify another by adding
oci_region              = "your-region"

IMPORTANT: Ensure that you have a VM.Standard2.2 available in Service Limits for the region

*/

oci_vcn_name            = "dev-db-vcn" 
vcn_public_subnet_cidr  = "10.10.0.0/24"
vpn_gw_name             = "oci-user-vpn-gw1"       

vpn_users = {
  user1 = {
    user_name        = "jim"
    user_email       = "jim@abc.com"
  }
  user2 = {
    user_name        = "bob"
    user_email       = "bob@abc.com"
  }
  user3 = {
    user_name        = "alice"
    user_email       = "alice@abc.com"
  }
  user4 = {
    user_name        = "scott"
    user_email       = "scott@abc.com"
  }
  user5 = {
    user_name        = "tiger"
    user_email       = "tiger@abc.com"
  }        
}