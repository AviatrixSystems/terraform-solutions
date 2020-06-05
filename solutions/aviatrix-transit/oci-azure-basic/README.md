# Aviatrix Transit - OCI <> Azure Transit

## Description

This example will build [Aviatrix Transit](https://docs.aviatrix.com/HowTos/transitvpc_workflow.html) between OCI and Azure including all of the infrastructure in both clouds.

Aviatrix automates the workflow while providing ongoing visibility, control, and the means to do this with multiple accounts and multicloud.

- VCNs, VNETs, Transit Gateway, Spoke Gateways with connected transit

<div style="width: 960px; height: 720px; margin: 10px; position: relative;"><iframe src="https://app.lucidchart.com/documents/embeddedchart/fa6272a2-0fb7-4903-bf8a-d54170a1bde9" id="84v5JmR~1lWX" frameborder="0" allowfullscreen="allowfullscreen" height="100%" width="100%"></iframe></div>

## Prerequisites

- Aviatrix Controller can be launched in from OCI Marketplace in a few minutes instructions [here.](https://youtu.be/bP6X2Y2w_aA)
- OCI Access Account onboarded to Controller instructions [here.](https://docs.aviatrix.com/HowTos/oracle-aviatrix-cloud-controller-onboard.html)
- Azure Access Account onboarded to Controller instructions [here.](https://docs.aviatrix.com/HowTos/Aviatrix_Account_Azure.html)
- ```VMStandard2.2``` shapes available in OCI region(s), check limits
- ```Standard_B1s``` available in Azure region(s)
- The region defaults are ```us-ashburn-1``` and ```East US``` you can modify them by adding your own in ```terraform.tfvars```

  
## Getting Started

- Modify ```terraform.tfvars``` with values for **your** Controller details specifying the ```controller ip, username, password, oci_account_name, azure_acccount_name```
- ```terraform init```
- ```terraform plan```
- ```terraform apply```
- To destroy ```terraform destroy``` 

## What to expect

The Terraform automation will take ~20 minutes, you can monitor progress in the Aviatrix Controller, OCI Console, Azure Portal, or the terminal.

When complete your OCI spoke VCN and Azure VCN will be able to communicate through Aviatrix Transit.

Enjoy!



