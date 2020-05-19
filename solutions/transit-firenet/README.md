# Transit Firenet 

## Description

This example will build a transit firenet (Aviatrix Transit) including everything needed to run it.

- VCNs, Transit Gateways, Spoke Gateways, FireNet Instances, and Policy

## Prerequisites

- Aviatrix Controller with Access Account configured
- Subscription through CSP Marketplace (AWS, Azure, etc.) for the NGFW Vendor product (CheckPoint, Palo Alto, etc.)
  
## Runbook

- Modify terraform.tfvars with values for **your** Controller (examples for common firewall images are there)
- terraform init
- terraform plan
- terraform apply
- terraform destroy 

### This automation will take a while to run (around 30-40 minutes), you can monitor what's getting provisioned in your terminal or watch in the Controller 
