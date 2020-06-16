# Palo Alto Networks Azure

Aviatrix Transit FireNet (PAN) deployment in Azure

## Summary

Example to build Aviatrix Transit Firenet (VNETs, GWs, Firewall instances, Inspection policies).

<img alt="PAN Azure transit firenet" src="https://github.com/AviatrixSystems/terraform-solutions/raw/master/solutions/img/azure-transit-firenet-pan.png">0

**Fully automated deployment of 2 PAN 9.0.1 NGFWs in Azure with supporting Transit infrastructure.**

## Prerequisites

- Aviatrix Controller with Access Accounts defined for Azure
- Subscription to ```Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1``` in Azure Marketplace
- appropriate cpu limits in the target region
- terraform .12

## To run it

- ```terraform init```
- ```terraform plan```
- ```terraform apply --auto-approve```
- To Destroy ```terraform destroy --auto-approve```

## What to expect

This will take **~40 minutes** to run, observe in the Controller UI or terminal.
