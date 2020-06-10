# Terraform Solutions

Welcome to Aviatrix Terraform Solutions!

This repository will contain various examples of Aviatrix solutions integral to MCNA implemented with Terraform. In general this is intended to assist you with building what you need or getting very close to it. 

## MCNA

**Multicloud Network Architecture (MCNA)** is a repeatable framework created by Aviatrix architects to build and manage Enterprise grade cloud networks. The lucid diagram below is an interactive example of MCNA architecture spanning multiple clouds leveraging Aviatrix controller and gateways.

Using the Mind Map buttons on the top you can see the MCNA architecture rendered. Try the **ALL** and **RESET** buttons, then click on the other **use case** buttons to see the Multicloud data plane come to life.

<div style="width: 960px; height: 720px; margin: 10px; position: relative;"><iframe src="https://app.lucidchart.com/documents/embeddedchart/a5205086-cabd-4072-8f0a-77fcc1b13ed5" id="Hlw5BRlL2euK" frameborder="0" allowfullscreen="allowfullscreen" height="100%" width="100%"></iframe></div>

## Prerequisites

- Understanding of Terraform, how to setup your environment to use it and the Terraform workflow ```init, plan, apply, destroy```
- Understanding of the files associated with Terraform, including ```main.tf, variables.tf, terraform.tfvars``` and how to make changes needed for your requirements.

## Getting Started

If you are new to Aviatrix the first thing you will need to do is launch a Controller. You may be operating in one Cloud today most organizations plan to operate in many *(Multicloud)*. Typically organizations will have a *Primary* Cloud where governance and other shared processes are centralized in. Wherever you are (AWS,Azure,OCI,GCP) is fine. 

**One** Controller is all you need to deploy the solutions.

Take a look in the [controller-launch](./controller-launch) directory and launch one yourself.

## [Solutions](./solutions)

Aviatrix has a number of workflows to achieve advanced Cloud Networking configurations **(use cases)**. You can read more about them [here](https://docs.aviatrix.com/) or attend one of our live [events](https://aviatrix.com/events/).

The definition of a **Solution** in the scope of this repository is the Terraform code required to implement one or more of the **use cases** available through the [Aviatrix Terraform Provider](https://www.terraform.io/docs/providers/aviatrix/index.html).

To implement any of the **Solutions** you will need to launch a Controller **first**.

Take a look in the [solutions](./solutions) directory and try them out.

Enjoy!



