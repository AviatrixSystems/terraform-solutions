# Transit Firenet - CheckPoint AWS

## Description

This example will build a transit firenet (Aviatrix Transit) including everything needed to run it.

- VCNs, Transit Gateways, Spoke Gateways, FireNet Instances, and Policy
- The *tfvars file specifies ```Check Point CloudGuard IaaS All-In-One``` you can change it to ```Check Point CloudGuard IaaS Next-Gen Firewall w. Threat Prevention & SandBlast BYOL``` if you like
  

## Prerequisites

- Aviatrix Controller with Access Account configured
- Subscription through AWS Marketplace for the NGFW Vendor product (CheckPoint)
  
## Runbook

- Modify terraform.tfvars with values for **your** Controller (examples for common firewall images are there)
- terraform init
- terraform plan
- terraform apply
- terraform destroy 

### This automation will take a while to run (around 30-40 minutes), you can monitor what's getting provisioned in your terminal or watch in the Controller 
