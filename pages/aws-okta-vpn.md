---
title: Multi-Cloud User VPN with Okta
subtitle: Deploy User VPN using Okta SAML IdP in minutes
layout: page
show_sidebar: false
---

## Summary
This solution deploys an Aviatrix multi-cloud User VPN architecture, using Okta as SAML Identity Provider. 

<img alt="multi-tenant saas architecture" src="https://github.com/AviatrixSystems/terraform-solutions/raw/master/solutions/img/okta-user-vpn.png">

## Demo
A demo can be found [here](https://youtu.be/DXdCYoC74sA).

## Scenario
The center of gravity is shifting to the cloud and remote users now need to VPN directly into the cloud.  This is achieved with Aviatrix VPN gateways that connect back to an Aviatrix transit architecture to reach the cloud workloads.  The diagram shows AWS but the code can work with any type of cloud.  That's the power of Aviatrix: a multi-cloud platform exposed via a unique Terraform provider.

Additionally, enterprises are deploying 3rd-party Identity Providers (IDPs) to store the user definitions and take care of user authentication.

Aviatrix seamlessly integrates with IDPs via SAML.  This particular code integrates with Okta.

## Benefits
This deployment of this architecture is entirely automated with this Terraform script.

It automates Okta for Aviatrix User VPN:
* Create Okta users.
  * Aviatrix VPN profiles association to the users is also defined in Okta.  This is called profile as SAML attribute.
* Create Okta app for Aviatrix.
* Retrieve the SAML metadata of the app, for input to the Aviatrix controller in the next step.
* Every property (users, profiles, app, etc.) can be modified from variables.tf.

It automates also the entire Aviatrix User VPN architecture:
* User VPN VPC
* User VPN gateways.
  * The current code deploys two VPN gateways.  Variables.tf can easily be adjusted to deploy less or more VPN gateways.
  * The Aviatrix controller automatically spins up a cloud load balancer to front end the gateways and attaches the gateways to the load balancer.
* Split-tunnel mode on the VPN gateways.
  * The split-tunnel CIDRs can be adjusted from variables.tf.
* Spoke gateway in the User VPN VPC.
* Spoke gateway ActiveMesh attachment to Aviatrix transit gateway.
* SAML endpoint to associate with Okta IDP.
* VPN user with shared certificate for all Okta users.
  * It's tied to the SAML endpoint and load balancer created earlier.
* VPN profile for tighter security to specific VPC CIDRs.
  * Again this can be adjusted from variables.tf.

## Prerequisites
* Aviatrix Controller up and running, details [here](https://docs.aviatrix.com/StartUpGuides/aviatrix-cloud-controller-startup-guide.html) showing how to launch one from the AWS Marketplace.
* AWS account defined in controller, details [here](https://docs.aviatrix.com/StartUpGuides/aviatrix-cloud-controller-startup-guide.html#select-aws).
* Aviatrix transit deployed.
* Either already have Terraform .12 installed on your workstation, or use the turn-key Aviatrix Docker image.

## Getting Started
* ```docker run -it aviatrix/automation:latest bash```
* ```cd ~/terraform-solutions/vpn/multi-cloud-okta```
* ```source setup.sh```
  * It will ask for your Aviatrix controller credentials, and Okta credentials.
  * It will open variables.tf for your to input your account, VPC name, CIDR, etc.
  * It will run Terraform for you.
* To destroy: ```terraform destroy```

## What to expect
The entire solution takes about 5 minutes to be deployed.

## Example
1. Start the Docker container
```[root@ip-10-50-125-136 ~]# docker run -it aviatrix/automation:latest bash
Unable to find image 'aviatrix/automation:latest' locally
latest: Pulling from aviatrix/automation
Status: Downloaded newer image for aviatrix/automation:latest
root@e81a2ade0c2e:/#```
 
2. Run setup.sh.
```root@e81a2ade0c2e:/# cd ~/terraform-solutions/vpn/multi-cloud-okta
root@e81a2ade0c2e:~/terraform-solutions/vpn/multi-cloud-okta# source setup.sh
Aviatrix controller IP: 
Aviatrix username: 
Aviatrix password:
Okta org name (for example, dev-111111): 
Okta base URL (typically okta.com): 
Okta API token (if you don't already have one: Okta -> Security -> Tokens -> Create Token):
Now opening Terraform config. Edit your settings, save, and quit the text editor when you're done.  Press any key to continue.
 
### User then inputs their parameters in the file…
variable "account_name" { default = "aws-network" }
variable "region" { default = "us-west-2" }
 
variable "uservpn_vpc" { default = "AWS-UW2-SAML-VPN-VPC" }
variable "uservpn_vpc_cidr" { default = "10.22.0.0/16" }
 
### AWS = 1, GCP = 4, Azure = 8, OCI = 16.
variable "cloud_type" { default = 1 }
 
### AWS gateways.
variable "vpn_gateways" {
  default = {
    gw1 = {
      name     = "AWS-UW2-SAML-VPN-GW-1"
      size     = "t3.small"
etc…
 
Now running terraform init, press any key to continue.
 
Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "okta" (terraform-providers/okta) 3.3.0...
- Downloading plugin for provider "aviatrix" (terraform-providers/aviatrix) 2.14.1...
 
Now running terraform plan, press any key to continue.
 
…
 
Terraform will perform the following actions:
 
  # aviatrix_gateway.vpn_gws["gw1"] will be created
  + resource "aviatrix_gateway" "vpn_gws" {
      + account_name                 = "aws-network"
      + additional_cidrs             = "10.21.0.0/16,10.25.0.0/16,10.26.0.0/16"
      + allocate_new_eip             = true
…
 
  # okta_user.vpn_users["user2"] will be created
  + resource "okta_user" "vpn_users" {
      + custom_profile_attributes = jsonencode({})
      + email                     = "john_dev@abc.com"
      + first_name                = "John"
      + id                        = (known after apply)
      + last_name                 = "Dev"
      + login                     = "john_dev@abc.com"
      + raw_status                = (known after apply)
      + status                    = "ACTIVE"
    }
 
Plan: 9 to add, 0 to change, 0 to destroy.
 
Now running terraform apply, press any key to continue.
 
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.
 
  Enter a value: yes
 
okta_user.vpn_users["user2"]: Creating...
okta_user.vpn_users["user1"]: Creating...
okta_user.vpn_users["user1"]: Creation complete after 1s [id=00ue5mmet29jBsqS04x6]
okta_user.vpn_users["user2"]: Creation complete after 1s [id=00ue5mydiPHKLXnV14x6]
okta_app_saml.tf-uservpn: Creating...
aviatrix_vpc.vpn_vpc: Creating...
aviatrix_vpn_profile.vpn_profile: Creating...
okta_app_saml.tf-uservpn: Creation complete after 2s [id=0oae5m2a7KbN2G1uN4x6]
aviatrix_saml_endpoint.avx_saml_endpoint: Creating...
aviatrix_vpc.vpn_vpc: Still creating... [10s elapsed]
aviatrix_vpn_profile.vpn_profile: Still creating... [10s elapsed]
aviatrix_vpc.vpn_vpc: Creation complete after 10s [id=AWS-UW2-SAML-VPN-VPC]
aviatrix_gateway.vpn_gws["gw1"]: Creating...
aviatrix_gateway.vpn_gws["gw2"]: Creating...
aviatrix_saml_endpoint.avx_saml_endpoint: Creation complete after 10s [id=okta_uservpn]
aviatrix_vpn_profile.vpn_profile: Creation complete after 11s [id=Developer-Profile]
aviatrix_vpn_user.vpn_user: Creation complete after 1m45s [id=aws-okta-shared-cert]
aviatrix_gateway.vpn_gws["gw2"]: Creation complete after 3m49s [id=AWS-UW2-SAML-VPN-GW-2]
…
aviatrix_gateway.vpn_gws["gw2"]: Creation complete after 3m49s [id=AWS-UW2-SAML-VPN-GW-2]
 
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.
 
Done.
root@e81a2ade0c2e:~/terraform-solutions/vpn/multi-cloud-okta#```