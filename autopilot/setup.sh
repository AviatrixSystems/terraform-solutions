#!/bin/bash

timer()
{
    temp_cnt=$1
    while [[ ${temp_cnt} -gt 0 ]];
    do
	printf "\r%2d second(s)" ${temp_cnt}
	sleep 1
	((temp_cnt--))
    done
    echo ""
}

read -n 1 -r -s -p $'--> Going to run aws configure to set your AWS settings. They stay local to this machine and are not shared. Press any key to continue.'
echo
aws configure

### Controller launch.
cd controller
read -n 1 -r -s -p $'\n--> Going to generate SSH keys for the controller. You can use an empty passphrase. Press any key to continue.'
ssh-keygen -t rsa -f ctrl_key -C "controller_public_key"

read -n 1 -r -s -p $'\n--> Go to https://aws.amazon.com/marketplace/pp?sku=b03hn7ck7yp392plmk8bet56k and subscribe to the Aviatrix platform. Press any key once you have subscribed.'

read -n 1 -r -s -p $'\n\n--> Now opening the settings file for the controller. You can leave the defaults or change to your preferences. Press any key to continue.'
vim variables.tf

read -n 1 -r -s -p $'\n\n--> Now running terraform init, press any key to continue.'
terraform init

read -n 1 -r -s -p $'\n\n--> Now running terraform apply, press any key to continue.'
terraform apply

# Store the outputs in environment variables for the controller init to use.
export AWS_ACCOUNT=$(terraform output aws_account)
export CONTROLLER_PRIVATE_IP=$(terraform output controller_private_ip)
export CONTROLLER_PUBLIC_IP=$(terraform output controller_public_ip)

echo AWS_ACCOUNT: $AWS_ACCOUNT
echo CONTROLLER_PRIVATE_IP: $CONTROLLER_PRIVATE_IP
echo CONTROLLER_PUBLIC_IP: $CONTROLLER_PUBLIC_IP

# echo "Waiting 5 minutes for the controller to come up..."
timer 300

### Controller init.
read -p 'Enter recovery email: ' email
export AVIATRIX_EMAIL=$email

read -sp 'Enter new password: ' password
export AVIATRIX_PASSWORD=$password

read -n 1 -r -s -p $'\n\n--> Now running controller initialization, press any key to continue.\n'
python3 controller_init.py


### MCNA launch.
export AVIATRIX_USERNAME="admin"
export AVIATRIX_CONTROLLER_IP=$CONTROLLER_PUBLIC_IP

### Done.
echo -e '\n--> Done.'
cd /root/ace-controller-build
