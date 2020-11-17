# Multi-Tenant Multi-Cloud SaaS Architecture with Policy-Based Site2Cloud and Overlapping IPs On-Prem

## Summary
This solution deploys an Aviatrix multi-cloud, multi-tenant SaaS architecture that handles overlapping on-prem customers.  On-prem customers reach the cloud shared services via policy-based Site2Cloud IPsec VPN, that terminates directly on Aviatrix ActiveMesh Spoke gateways.

Subnets of on-prem customers can overlap between each other, so in that case we land them on different Spoke gateways.
  - SNAT overload is used on the Spoke gateways for on-prem-initiated traffic.  Any source IP is NATed to the private IP of the Spoke gateway, which is unique in the Aviatrix network.
  - DNAT with virtual IPs is used for cloud-initiated traffic.  Cloud instances (shared services) uses a virtual IP when initiating a communication to on-prem resources.  This virtual IP is allocated in such a way that it's unique in the Aviatrix network, so the overlapping customer IPs are being differentiated.  This allows the traffic to land on the Spoke gateway under which the customer resides.  The Spoke gateway then DNATs the traffic back to the real IP of the on-prem workload because sending it over to the Site2Cloud IPsec VPN tunnel to on-prem.

<img alt="policy-based S2C NAT ActiveMesh" src="https://github.com/AviatrixSystems/terraform-solutions/raw/master/solutions/img/policy-based-s2c-nat-activemesh.png">

## Prerequisites
- Aviatrix Controller up and running, details [here](https://docs.aviatrix.com/StartUpGuides/aviatrix-cloud-controller-startup-guide.html) showing how to launch one from the AWS Marketplace.
- AWS access accounts defined in controller, details [here](https://docs.aviatrix.com/StartUpGuides/aviatrix-cloud-controller-startup-guide.html#select-aws).
- Aviatrix transit VPC and transit gateway already deployed.
- Aviatrix Spoke VPC and Spoke gateway for shared services already deployed (in the example, it's the 10.1.0.0/16 VPC).

This Terraform solution automates the deployment of the following components:
- Customer-facing Spoke VPCs
- Customer-facing Spoke gateways
- Attachment of those Spoke gateways to Transit gateways
- Association of those Spoke gateways to Segmentation domains
- Policy-based Site2Cloud IPsec VPN connection from Spoke gateways to on-prem routers
- SNAT on Spoke gateways for on-prem initiated-traffic
- DNAT on Spoke gateways for cloud-initiated traffic
- Customized Spoke VPC CIDR advertisement of virtual on-prem subnets for cloud-initiated traffic

## How to use the solution
* Set environment variables for your Aviatrix controller:
  * export AVIATRIX_CONTROLLER_IP="your-controller-ip"
  * export AVIATRIX_USERNAME="your-controller-usename"
  * export AVIATRIX_PASSWORD="your-controller-password"
* Modify ```variables.tf``` to reflect your information for VPCs, IP ranges, on-prem router IP and pre-shared key, NAT rules, etc.
* ```terraform init```
* ```terraform plan```
* ```terraform apply```
* To destroy: ```terraform destroy```
