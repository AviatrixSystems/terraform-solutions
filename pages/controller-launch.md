---
title: Controller Launch
subtitle: Establish your Multi-Cloud network control plane
layout: page
show_sidebar: false
---


## Workflow

<img alt="workflow" src="https://github.com/AviatrixSystems/terraform-solutions/raw/master/solutions/img/controller-launch-workflow.png">

The process get up and running with our Terraform Provider is **Launch Controller > Setup Cloud Access Accounts > Deploy Solutions**

Once you have a Controller up and running you can use the [Aviatrix Terraform Provider](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest) to build any of the Solutions. Just make sure that you have an Access Account onboarded for each Cloud provider you want to build in.

## AWS

Terraform Modules to launch Controller can be found [here.](https://github.com/AviatrixSystems/terraform-modules)

Instructions on how to onboard AWS access accounts to the Controller can be found [here.](https://docs.aviatrix.com/HowTos/aviatrix_account.html)

## Azure

Terraform to launch a Controller in Azure can be found [here.](https://github.com/AviatrixSystems/terraform-solutions/tree/master/controller-launch/aviatrix-azure-controller)

Instructions on how to onboard Azure access accounts to the Controller can be found [here.](https://docs.aviatrix.com/HowTos/Aviatrix_Account_Azure.html)

## GCP

Instructions on how to launch a Controller in GCP can be found [here.](https://docs.aviatrix.com/StartUpGuides/google-aviatrix-cloud-controller-startup-guide.html)

Instructions on how to onboard GCP access accounts to the Controller can be found [here.](https://docs.aviatrix.com/HowTos/CreateGCloudAccount.html)


## OCI 

Terraform to launch a Controller in OCI can be found [here.](https://github.com/oracle-quickstart/oci-aviatrix/tree/master/controller)

Instructions on how to onboard OCI access accounts to the Controller can be found [here.](https://docs.aviatrix.com/HowTos/oracle-aviatrix-cloud-controller-onboard.html)


