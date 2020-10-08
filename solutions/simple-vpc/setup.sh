#! /bin/bash

read -p 'Aviatrix controller IP: ' aviatrix_controller_ip
read -p 'Aviatrix username: ' aviatrix_username
read -sp 'Aviatrix password: ' aviatrix_password
export AVIATRIX_CONTROLLER_IP=$aviatrix_controller_ip
export AVIATRIX_USERNAME=$aviatrix_username
export AVIATRIX_PASSWORD=$aviatrix_password

vim variables.tf

terraform init
terraform plan
terraform apply
