---
title: Multi-Cloud SaaS Architecture with Overlapping IPs
subtitle: Deploy a Multi-Cloud SaaS architecture in AWS & GCP in 30 minutes
layout: page
show_sidebar: false
---

## Summary
This solution deploys an Aviatrix multi-cloud, multi-tenant SaaS architecture with customized SNAT for overlapping on-prem data sources.  There is both dedicated and shared services for end-customers.

<img alt="multi-tenant saas architecture" src="https://github.com/AviatrixSystems/terraform-solutions/raw/master/solutions/img/multi-tenant-saas.png">

## Scenario
Multi-tenant SaaS provides services to different tenants i.e., end customers.  The services are hosted in the cloud.  There's two types of services:
1. Shared services that are used by every customer.  Hosted in both AWS and GCP, in VPCs AWS-Saas-Services-VPC and gcp-ew1-saas-services-vpc.
2. Local services that are isolated and specific to a given customer.  Hosted in a dedicated VPC that exists for every customer in AWS: AWS-EW1-SaaS-Cx-VPC.

Tenants send data to and access the services from on-prem.  Their dedicated VPC provides the entry point to the cloud via Site-to-Cloud (S2C) IPsec VPN connection landing on Aviatrix S2C gateways.

Local services are accessed directly since they're local in the VPC.  No NAT is required because they're only accessed by their customer.

Shared services are reached via an Aviatrix transit network.  Aviatrix spoke gateways in the customer-specific VPC are connected via ActiveMesh to Aviatrix transit gateways.  The transit gateways provide connectivity to the AWS shared services in AWS via ActiveMesh peering, and to the GCP shared services via a transit peering.

Customer can have overlapping IPs on prem.  Therefore, every Aviatrix S2C gateway is source-NATing the traffic destined to the shared services.  The packets coming from on-prem have their source IP change to the one of the S2C gateway.  S2C gateways have unique IPs since they reside in customer-local VPCs for which we control the CIDR and guarantee there is no overlap.

The Aviatrix multi-cloud control plane performs learning and route propagation within AWS and GCP and across those clouds.

## Benefits
This deployment of this architecture is entirely automated with this Terraform script.

It automates the entire Aviatrix multi-cloud architecture:
* All VPCs.
* All gateways: transit, spoke, S2C.
* ActiveMesh transit network.
* S2C connections to on-prem.
* Customized SNAT on S2C GWs towards the shared services VPC CIDR.
* Transit peering between AWS and GCP.

It also automates the entire test environment using AWS VPN gateways (VGWs) to simulate on-prem routers.
* AWS EC2 instances within the AVX network, for shared services and cloud customer-specific app.
  * This includes security groups to open ICMP and SSH.
* AWS VPCs to represent on-prem data centers.
  * They overlap and this is of course on purpose.
  * And test instances in there, which represent customers on-prem data sources.
* AWS VGWs to simulate on-prem routers.
  * Including VPC route table programming to point customer and shared services CIDR routes to VGW.
* AWS CGWs to tie back to AVX S2C GWs.
* AWS site-to-site VPN connection to AVX S2C GWs.
  * Including static routes back to customer VPC and to shared services VPC.
* AWS EC2 instances to simulate on-prem data sources.

This is completely dynamic. The code retrieves all parameters from the VGW (IPs, security keys…) and inputs them into the Aviatrix controller to build the S2C connection.

## Prerequisites
- Aviatrix Controller up and running, details [here](https://docs.aviatrix.com/StartUpGuides/aviatrix-cloud-controller-startup-guide.html) showing how to launch one from the AWS Marketplace.
- AWS and GCP access accounts defined in controller, details [here](https://docs.aviatrix.com/StartUpGuides/aviatrix-cloud-controller-startup-guide.html#select-aws) and [here.](https://docs.aviatrix.com/HowTos/CreateGCloudAccount.html)
- Terraform .12 on your workstation

## Getting Started
* Set environment variables for your Aviatrix controller:
  * export AVIATRIX_CONTROLLER_IP="your-controller-ip"
  * export AVIATRIX_USERNAME="your-controller-usename"
  * export AVIATRIX_PASSWORD="your-controller-password"
* Modify ```terraform.tfvars``` to reflect your information for controller, VPCs, IP ranges, SNAT rules, etc.
* ```terraform init```
* ```terraform plan```
* ```terraform apply```
* To destroy: ```terraform destroy```

## What to expect
The entire solution takes ~15 minutes to be deployed.
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTc5ODYyNjE1OF19
-->
