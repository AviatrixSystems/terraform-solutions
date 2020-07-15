// Copyright (c) 2020 Aviatrix Systems and/or its affiliates. All rights reserved.

# Recommend to set Controller secrets as environment variable
# $ export TF_VAR_password=yourpass
# $ export TF_VAR_controller_ip="your.controller.ip"

# Replace the values with your own
# terraform plan -var-file transit_firenet.tfvars
# standardDv2Family
#


# Aviatrix Controller
username           = "controllerusername"
password           = "yourpassword"    # These are here for development ONLY will be Environment Variables
controller_ip      = "123.123.123.123" # These are here for development ONLY will be Environment Variables
azure_account_name = "TM-Azure"        # This is the name of the Access Account per Cloud setup in your controller

# Transit FireNet Variables
avx_transit_gw   = "Transit-FireNet-GW" # Name of the AVX Transit Gateway
fw_image         = "Check Point CloudGuard IaaS Single Gateway R80.40 - Bring Your Own License"
fw_image_version = "8040.900294.0593"
# Azure Region 
region = "East US"

# Azure GW Size
avx_gw_size = "Standard_B2ms"

# Azure FW Instnace Size
firewall_size = "Standard_D3_v2"

# Azure VPC Count for Azure 
vpc_count = 2

# Azure Cloud Type - Aviatrix
cloud_type = 8


