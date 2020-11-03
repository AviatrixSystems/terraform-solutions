---
title: Palo Alto Networks Azure
subtitle: Deploy PAN VM-Series on Azure in under an hour
layout: page
show_sidebar: false
---

## Summary

This example will build a transit firenet (Aviatrix Transit) including everything needed to run it.

<img alt="PAN Azure transit firenet" src="https://github.com/AviatrixSystems/terraform-solutions/raw/master/solutions/img/azure-transit-firenet-pan.png">

**Fully automated deployment of 2 PAN 9.0.1 NGFWs in Azure with supporting Transit infrastructure.**

## Prerequisites

- Aviatrix Controller with Access Accounts defined for Azure
- Subscription to ```Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1``` in Azure Marketplace
- appropriate cpu limits in the target region
- terraform .12

### Workflow

Replace values with REPLACE_ME in terraform.tfvars

- ```terraform init```
- ```terraform plan```
- ```terraform apply --auto-approve```

### Software 

Component | Version
--- | ---
Aviatrix Controller | (6.2) UserConnect-6.2.1742 
Aviatrix Terraform Provider | 2.17
Terraform | 0.12

### Modules

Module Name | Version | Description
:--- | :--- | :---
[terraform-aviatrix-modules/azure-transit-firenet/aviatrix](https://registry.terraform.io/modules/terraform-aviatrix-modules/azure-transit-firenet/aviatrix/latest) | 2.0.1 | This module deploys a VNET, Aviatrix transit gateways and firewall instances
[terraform-aviatrix-modules/azure-spoke/aviatrix](https://registry.terraform.io/modules/terraform-aviatrix-modules/azure-spoke/aviatrix/latest) | 2.0.1 | This module deploys a VNET and an Aviatrix spoke gateway in Azure and attaches it to an Aviatrix Transit Gateway

## What to expect

This will take **~40 minutes** to run, observe in the Controller UI or terminal.
