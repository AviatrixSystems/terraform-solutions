---
title: Check Point Azure
subtitle: Deploy Check Point CloudGuard on Azure in under an hour
layout: page
show_sidebar: false
---

## Summary

Example to build Aviatrix Transit Firenet (VNETs, GWs, Firewall instances, Inspection policies).

<img alt="Check Point Azure transit firenet" src="https://github.com/AviatrixSystems/terraform-solutions/raw/master/solutions/img/azure-transit-firenet-checkpoint.png">0

**Fully automated deployment of 2 Check Point CloudGuard IaaS Single Gateway R80.40 NGFWs in Azure with supporting Aviatrix Transit infrastructure.**

## Prerequisites

- Aviatrix Controller 6.0 with Access Accounts defined for Azure
- Verify you can access ```Check Point CloudGuard IaaS Single Gateway R80.40 - Bring Your Own License``` in Azure Marketplace
- appropriate cpu limits in region including ```Standard_B2ms``` and ```Standard_D3_v2``` compute shapes
- terraform .12

## Getting Started

The code for this example can be found [here.](https://github.com/AviatrixSystems/terraform-solutions/tree/master/solutions/transit-firenet/checkpoint-azure)

- ```terraform init```
- ```terraform plan```
- ```terraform apply --auto-approve```
- To Destroy ```terraform destroy --auto-approve```

## What to expect

This will take **~45 minutes** to run, observe in the Controller UI or terminal.
