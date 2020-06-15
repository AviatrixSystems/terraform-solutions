---
title: CheckPoint AWS
subtitle: Deploy CheckPoint on AWS in under an hour
layout: page
show_sidebar: false
---

## Summary

This example will build a transit firenet (Aviatrix Transit) including everything needed to run it.

<img alt="Checkpoint AWS transit firenet" src="https://github.com/AviatrixSystems/terraform-solutions/raw/master/solutions/img/aws-transit-firenet-checkpoint.png">

- VCNs, Transit Gateways, Spoke Gateways, FireNet Instances, and Policy
- The *tfvars file specifies ```Check Point CloudGuard IaaS All-In-One``` you can change it to ```Check Point CloudGuard IaaS Next-Gen Firewall w. Threat Prevention & SandBlast BYOL``` if you like
  

## Prerequisites

- Aviatrix Controller with Access Account configured
- Subscription through AWS Marketplace for the NGFW Vendor product (CheckPoint)

## Getting Started

The code for this example can be found [here.](https://github.com/AviatrixSystems/terraform-solutions/tree/master/solutions/transit-firenet/checkpoint-aws)

- Modify terraform.tfvars with values for **your** Controller (examples for common firewall images are there)
- ```terraform init```
- ```terraform plan```
- ```terraform apply```
- To Destroy ```terraform destroy```

### This will take **~40 minutes** to run, observe in the Controller UI or terminal. 
