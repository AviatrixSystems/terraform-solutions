// Copyright (c) 2020 Aviatrix Systems and/or its affiliates. All rights reserved.

# Recommend to set Controller secrets as environment variable
# $ export TF_VAR_password=yourpass
# $ export TF_VAR_controller_ip="your.controller.ip"

# Replace the values with your own
# terraform plan -var-file transit_firenet.tfvars
# standardDv2Family
#


# Aviatrix Controller
username        = "tfdev"
password        = "YOURPASS#123"      # These are here for development ONLY will be Environment Variables
controller_ip   = "3.999.102.46"      # These are here for development ONLY will be Environment Variables
azure_account_name    = "TM-Azure"    # This is the name of the Access Account per Cloud setup in your controller

# Transit FireNet Variables
avx_transit_gw  = "Azure-West-Transit-GW"
fw_image        = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"

# Azure Region 1
region          = "West US"

# Azure GW Size
avx_gw_size     = "Standard_B2ms"

# Azure FW Instnace Size
firewall_size   = "Standard_D3_v2"

# Azure VPC Count for Azure 
vpc_count       = 2

# Firewall Images to use for provisioning - replace as needed
/*
firewall_images = {
  palo_aws           = "Palo Alto Networks VM-Series Next-Generation Firewall (BYOL)"
  palo_azure         = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
  checkpoint_aws     = "Check Point CloudGuard IaaS Next-Gen Firewall w. Threat Prevention & SandBlast BYOL"
  checkpoint_aws     = "Check Point CloudGuard IaaS All-In-One"
}
*/

cloud_type      = 8
# Aviatrix TF Provider Cloud Types - replace as needed
/*
  1 for AWS
  4 for GCP
  8 for AZURE
  16 for OCI
  256 for AWS Gov
*/

