# OCI User VPN

## Summary

This solution deploys an Aviatrix OpenVPN enabled gateway into an existing VCN with a public subnet, and onboards 5 users to it.

Details of the Aviatrix OpenVPN features can be found [here.](https://docs.aviatrix.com/HowTos/openvpn_features.html)

## Scenario

Executives, SecOPs, Cloud Operations, and DBAs want simple, secure, centralized visibility, and control accessing Oracle database resources created in private subnets.

Bastion hosts and proliferation of ssh keys are security risks.

DBAs who need to manage databases, want an easy way to access the databases they are responsible for managing. 

<div style="width: 960px; height: 720px; margin: 10px; position: relative;"><iframe src="https://app.lucidchart.com/documents/embeddedchart/bd95cda7-d6ed-476c-aa5b-283968436aa1" id="rD94HpEJKTll" frameborder="0" allowfullscreen="allowfullscreen" height="100%" width="100%"></iframe></div>

## Benefits

OpenVPN deployment to the target VCN is automated, in addition to onboarding the users that need access. This solution can be deployed in about 5 minutes.

## Prerequisites

- Aviatrix Controller up and running, details [here](https://youtu.be/bP6X2Y2w_aA) showing how to launch one from OCI Marketplace.
- OCI Access Account defined in controller, details [here.](https://docs.aviatrix.com/HowTos/oracle-aviatrix-cloud-controller-onboard.html)
- ```VMStandard2.2``` compute available in your region, check your limits
- Terraform .12 on your workstation

## Getting Started

- Modify ```terraform.tfvars``` to reflect your Controller details and the name of the OCI Access Account defined there.
- Identify the target vcn, capture it's name and the public subnet CIDR. You can do this through the OCI Console.
- Modify ```terraform.tfvars``` to reflect your oci vcn name and public subnet cidr.
- Modify ```terraform.tfvars``` to reflect the users you would like to onboard.
- ```terraform init```
- ```terraform plan```
- ```terraform apply```
- To destroy ```terraform destroy```

## What to expect

The Aviatrix VPN gateway will take ~3 minutes to provision, users will be onboarded quickly thereafter.

Users will recieve an email with the ```*.opvn``` file with instructions they can use with Tunnelblick or download the [Aviatrix VPN Client.](https://docs.aviatrix.com/Downloads/samlclient.html)

## VPN Users in Controller
<img width="964" alt="VPN Users" src="https://github.com/AviatrixSystems/terraform-solutions/blob/master/solutions/img/oci-vpn-users.png">

