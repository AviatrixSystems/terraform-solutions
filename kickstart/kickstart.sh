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

aws_configure()
{
    read -n 1 -r -s -p $'--> Going to run aws configure to set your AWS settings. They stay local to this container and are not shared. Access keys can be created in AWS console under Account -> My Security Credentials -> Access keys for CLI, SDK, & API access. Default region name and Default output format can be left to None. Press any key to continue.\n'
    echo
    aws configure
}

controller_launch()
{
    cd /root/terraform-solutions/kickstart/controller
    read -n 1 -r -s -p $'\n--> Going to generate SSH keys for the controller. You can use an empty passphrase. Press any key to continue.\n'
    ssh-keygen -t rsa -f ctrl_key -C "controller_public_key"

    read -n 1 -r -s -p $'\n--> Go to https://aws.amazon.com/marketplace/pp?sku=b03hn7ck7yp392plmk8bet56k and subscribe to the Aviatrix platform. Only click on "Continue to subscribe". Do NOT click on "Continue to Configuration". Press any key once you have subscribed.\n'

    read -n 1 -r -s -p $'\n\n--> Now opening the settings file for the controller. You can leave the defaults or change to your preferences. Press any key to continue. In the text editor, press :wq when done.\n'
    vim variables.tf

    read -n 1 -r -s -p $'\n\n--> The controller user configuration is now complete. Now going to launch the controller instance in AWS. Press any key to continue. Close the window, or press Ctrl-C to abort.\n'
    terraform init
    terraform apply -auto-approve

    if [ $? -eq 0 ]; then
	echo "Controller successfully launched."
    else
	echo "Controller launch failed, aborting." >&2
	return
    fi

    # Store the outputs in environment variables for the controller init to use.
    export AWS_ACCOUNT=$(terraform output aws_account)
    export CONTROLLER_PRIVATE_IP=$(terraform output controller_private_ip)
    export CONTROLLER_PUBLIC_IP=$(terraform output controller_public_ip)

    echo AWS_ACCOUNT: $AWS_ACCOUNT
    echo CONTROLLER_PRIVATE_IP: $CONTROLLER_PRIVATE_IP
    echo CONTROLLER_PUBLIC_IP: $CONTROLLER_PUBLIC_IP

    echo "Waiting 5 minutes for the controller to come up..."
    timer 300
}

controller_init()
{
    cd /root/terraform-solutions/kickstart/controller
    echo
    read -p 'Enter recovery email: ' email
    export AVIATRIX_EMAIL=$email

    while true; do
	read -s -p "Enter new password: " password
	echo
	read -s -p "Confirm new password: " password2
	echo
	[ "$password" = "$password2" ] && break
	echo "Passwords don't match, please try again."
    done
    export AVIATRIX_PASSWORD=$password

    python3 controller_init.py
    echo "Controller is ready."
}

mcna_init()
{
    cd /root/terraform-solutions/kickstart/mcna
    export AVIATRIX_USERNAME="admin"
    export AVIATRIX_CONTROLLER_IP=$CONTROLLER_PUBLIC_IP
    export TF_VAR_ec2_key=""

    read -n 1 -r -s -p $'\n\n--> Now opening the settings file for the multi-cloud deployment. You can leave the defaults or change to your preferences. Go to https://raw.githubusercontent.com/AviatrixSystems/terraform-solutions/master/solutions/img/kickstart.png to view what is going to be launched. If you are not in Azure, you can ignore the Azure credentials. If you are in Azure, perform the pre-requisites at https://docs.aviatrix.com/HowTos/Aviatrix_Account_Azure.html. Press any key to continue. In the text editor, press :wq when done.\n'
    vim variables.tf
}

mcna_aws_transit()
{
    cd /root/terraform-solutions/kickstart/mcna
    read -n 1 -r -s -p $'\n\n--> Now going to launch gateways in AWS. Press any key to continue.\n'
    terraform init
    terraform apply -target=aviatrix_transit_gateway.aws_transit_gw -target=aviatrix_spoke_gateway.aws_spoke1_gw -target=aviatrix_spoke_gateway.aws_spoke2_gw -auto-approve
}

input_aws_keypair()
{
    read -p $'\n\n--> Enter your AWS keypair name you want to use for the test EC2 instances. If needed, go to EC2 -> Network & Security -> Key Pairs to create one.\nKeypair: ' keypair
    export TF_VAR_ec2_key=$keypair
}

mcna_aws_test_instances()
{
    cd /root/terraform-solutions/kickstart/mcna
    read -p $'\n\n--> Do you want to lauch test EC2 instances in the AWS Spoke VPCs? (y/n)? ' answer
    if [ "$answer" != "${answer#[Yy]}" ] ; then
	input_aws_keypair
	terraform apply -target=aws_instance.test_instances -auto-approve
    else
	echo "Skipping test EC2 instances"
    fi
}

mcna_azure_transit()
{
    cd /root/terraform-solutions/kickstart/mcna
    read -p $'\n\n--> Do you want to lauch gateways in Azure, and peer AWS and Azure (y/n)? ' answer
    if [ "$answer" != "${answer#[Yy]}" ] ; then
	terraform apply -target=aviatrix_transit_gateway.azure_transit_gw -target=aviatrix_spoke_gateway.azure_spoke1_gw -target=aviatrix_spoke_gateway.azure_spoke2_gw -auto-approve
	terraform apply -target=aviatrix_transit_gateway_peering.aws_azure -auto-approve
    else
	echo "Skipping Azure"
    fi
}

banner Aviatrix Kickstart
aws_configure
controller_launch
controller_init
mcna_init
mcna_aws_transit
mcna_aws_test_instances
mcna_azure_transit

echo -e "\n--> Aviatrix Kickstart is done. Your controller IP is $CONTROLLER_PUBLIC_IP"
cd /root/terraform-solutions/kickstart
