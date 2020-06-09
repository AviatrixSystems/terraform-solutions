#!/bin/bash

read -p 'Aviatrix controller IP: ' aviatrix_controller_ip
read -p 'Aviatrix username: ' aviatrix_username
read -sp 'Aviatrix password: ' aviatrix_password
echo
read -p 'Okta org name (for example, dev-111111): ' okta_org_name
read -p 'Okta base URL (typically okta.com): ' okta_base_url
read -sp 'Okta API token (if you don'"'"'t already have one: Okta -> Security -> Tokens -> Create Token): ' okta_api_token
echo

# For Aviatrix terraform module
export AVIATRIX_CONTROLLER_IP=$aviatrix_controller_ip
export AVIATRIX_USERNAME=$aviatrix_username
export AVIATRIX_PASSWORD=$aviatrix_password

# For Okta Terraform module
export TF_VAR_AVX_CONTROLLER_IP=$aviatrix_controller_ip
export TF_VAR_OKTA_ORG_NAME=$okta_org_name
export TF_VAR_OKTA_BASE_URL=$okta_base_url
export TF_VAR_OKTA_API_TOKEN=$okta_api_token

read -n 1 -r -s -p $'Now opening Terraform config. Edit your settings, save, and quit the text editor when you'"'"'re done.  Press any key to continue. '
emacs variables.tf

read -n 1 -r -s -p $'\n\nNow running terraform init, press any key to continue. '
terraform init

read -n 1 -r -s -p $'\n\nNow running terraform plan, press any key to continue. '
terraform plan

read -n 1 -r -s -p $'\n\nNow running terraform apply, press any key to continue. '
terraform apply

echo "Done."
