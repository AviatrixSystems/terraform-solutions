---
title: Palo Alto Networks Azure
subtitle: Deploy PAN VM-Series on Azure in under an hour
layout: page
show_sidebar: false
---

## Summary

This example will build a transit firenet (Aviatrix Transit) including everything needed to run it.

<img alt="PAN Azure transit firenet" src="https://github.com/AviatrixSystems/terraform-solutions/raw/master/solutions/img/azure-transit-firenet-pan.png">

- VNETs, Transit Gateways, Spoke Gateways, FireNet Instances, and Policy
- The *tfvars file specifies ```Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1``` 
  

## Prerequisites

- Aviatrix Controller with Access Accounts defined for Azure
- Subscription to ```Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1``` in Azure Marketplace
- appropriate Resource Manager cpu limits in the target region
- terraform .12
  
## Getting Started

The code for this example can be found [here.](https://github.com/AviatrixSystems/terraform-solutions/tree/master/solutions/transit-firenet/pan-azure)

- Modify terraform.tfvars with values for **your** Controller (examples for common firewall images are there)
- ```terraform init```
- ```terraform plan```
- ```terraform apply```
- To Destroy ```terraform destroy ```

### This will take **~40 minutes** to run, observe in the Controller UI or terminal. 
