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
    if [ -d "/root/.aws" ]
    then
	echo "--> .aws exists, skipping aws configure."
	return 0
    fi
    echo "--> Going to get your AWS API access keys. They are required to launch the Aviatrix controller in AWS. They stay local to this container and are not shared. Access keys can be created in AWS console under Account -> My Security Credentials -> Access keys for CLI, SDK, & API access."
    read -p '--> Enter AWS access key ID: ' key_id
    read -p '--> Enter AWS secret access key: ' secret_key
    aws configure set aws_access_key_id $key_id
    aws configure set aws_secret_access_key $secret_key
}

record_controller_launch()
{
    payload="{\"controllerIP\":\"$CONTROLLER_PUBLIC_IP\"}"
    echo $payload
    curl -d $payload -H 'Content-Type: application/json' https://vyidaoc6pa.execute-api.us-west-2.amazonaws.com/v1/controller
}

generate_controller_ssh_key()
{
    cd /root/controller
    if [ -f "ctrl_key" ]; then
	echo "--> Controller SSH key already exists, skipping."
	return 0
    fi
	
    echo "--> Generating SSH key for the controller..."
    ssh-keygen -t rsa -f ctrl_key -C "controller_public_key" -q -N ""
    if [ $? -eq 0 ]; then
	echo "--> Done."
	return 0
    else
	echo "--> SSH key generation failed, aborting." >&2
	return 1
    fi
}

controller_launch()
{
    cd /root/controller
    
    generate_controller_ssh_key
    if [ $? -eq 0 ]; then
	echo "--> OK."
    else
	echo "--> Aborting." >&2
	return 1
    fi

    read -n 1 -r -s -p $'\n--> Go to https://aws.amazon.com/marketplace/pp?sku=b03hn7ck7yp392plmk8bet56k and subscribe to the Aviatrix platform. Click on "Continue to subscribe", and accept the terms. Do NOT click on "Continue to Configuration". Press any key once you have subscribed.\n'

    read -n 1 -r -s -p $'\n\n--> Now opening the settings file for the controller. You can leave the defaults or change to your preferences. Press any key to continue. In the text editor, press :wq when done.\n'
    vim variables.tf

    read -n 1 -r -s -p $'\n\n--> The controller user configuration is now complete. Now going to launch the controller instance in AWS. The public IP of the controller will be shared with Aviatrix for tracking purposes. Press any key to continue. Close the window, or press Ctrl-C to abort.\n'
    terraform init
    terraform apply -auto-approve

    if [ $? -eq 0 ]; then
	echo "--> Controller successfully launched."
    else
	echo "--> Controller launch failed, aborting." >&2
	return 1
    fi

    # Store the outputs in environment variables for the controller init to use.
    export AWS_ACCOUNT=$(terraform output aws_account)
    export CONTROLLER_PRIVATE_IP=$(terraform output controller_private_ip)
    export CONTROLLER_PUBLIC_IP=$(terraform output controller_public_ip)
    export AVIATRIX_CONTROLLER_IP=$CONTROLLER_PUBLIC_IP
    
    # Keep them in .bashrc in case the container gets restarted.
    f=/root/.kickstart_restore
    echo 'cd /root/controller' > $f
    echo 'export AWS_ACCOUNT=$(terraform output aws_account)' >> $f
    echo 'export CONTROLLER_PRIVATE_IP=$(terraform output controller_private_ip)' >> $f
    echo 'export CONTROLLER_PUBLIC_IP=$(terraform output controller_public_ip)' >> $f
    echo 'export AVIATRIX_CONTROLLER_IP=$CONTROLLER_PUBLIC_IP' >> $f
    
    echo AWS_ACCOUNT: $AWS_ACCOUNT
    echo CONTROLLER_PRIVATE_IP: $CONTROLLER_PRIVATE_IP
    echo CONTROLLER_PUBLIC_IP: $CONTROLLER_PUBLIC_IP

    record_controller_launch

    echo
    echo "--> Waiting 5 minutes for the controller to come up... Do not access the controller yet."
    timer 300
    return 0
}

controller_init()
{
    cd /root/controller
    echo
    read -p '--> Enter recovery email: ' email
    export AVIATRIX_EMAIL=$email
    f=/root/.kickstart_restore
    echo "export AVIATRIX_EMAIL=$email" >> $f
    
    while true; do
	read -s -p "--> Enter new password: " password
	echo
	read -s -p "--> Confirm new password: " password2
	echo
	[ "$password" = "$password2" ] && break
	echo "--> Passwords don't match, please try again."
    done
    export AVIATRIX_PASSWORD=$password
    str="export AVIATRIX_PASSWORD='$password'"
    echo $str >> $f

    export AVIATRIX_USERNAME=admin
    echo 'export AVIATRIX_USERNAME=admin' >> $f
    
    python3 controller_init.py
    echo "--> Controller is ready. Do not manually change the controller version while Kickstart is running."
}

mcna_init()
{
    cd /root/mcna
    vim variables.tf
}

mcna_aws_transit()
{
    cd /root/mcna
    read -n 1 -r -s -p $'\n\n--> Now going to launch gateways in AWS. Press any key to continue.\n'
    terraform init
    terraform apply -target=aviatrix_transit_gateway.aws_transit_gw -target=aviatrix_spoke_gateway.aws_spoke_gws -auto-approve
    return $?
}

input_aws_keypair()
{
    read -n 1 -r -s -p $'\n\n--> Re-opening the settings file. Make sure your key pair name is correct under aws_ec2_key_name. This is your own key pair, not Aviatrix keys for controller or gateways. Also make sure you are in the region where you launched the Spoke gateways. Press any key to continue.\n'
    vim variables.tf
}

mcna_aws_test_instances()
{
    cd /root/mcna
    input_aws_keypair
    read -n 1 -r -s -p $'\n\n--> Make sure that your AWS quota allows us to have more that 5 Elastic IPs. You can check your quota and request an increase at https://console.aws.amazon.com/servicequotas if needed. Press any key to continue.\n'
    echo "--> Launching instances now"
    terraform apply -target=aws_instance.test_instances -auto-approve
}

mcna_azure_transit()
{
    cd /root/mcna
    terraform apply -target=aviatrix_transit_gateway.azure_transit_gw -target=aviatrix_spoke_gateway.azure_spoke_gws -auto-approve
    return $?
}

peering()
{
    cd /root/mcna
    terraform apply -target=aviatrix_transit_gateway_peering.aws_azure -auto-approve
    return $?
}

banner Aviatrix Kickstart
cat /root/.plane

aws_configure

# If controller was already launched in this container, skip.
if [[ -v CONTROLLER_PUBLIC_IP ]]; then
    echo "--> Controller already launched, skipping."
else
    read -p $'\n\n--> Do you want to launch the controller? (y/n)? ' answer
    if [ "$answer" != "${answer#[Yy]}" ] ; then
	controller_launch
	if [ $? != 0 ]; then
	    echo "--> Controller launch failed, aborting."
	    return 1
	fi
	controller_init
	if [ $? != 0 ]; then
	    echo "--> Controller init failed, aborting."
	    return 1
	fi
    fi
fi

read -p $'\n\n--> Do you want to launch the Aviatrix transit in AWS? (y/n)? ' answer
if [ "$answer" != "${answer#[Yy]}" ] ; then
    read -n 1 -r -s -p $'\n\n--> Now opening the settings file for the AWS deployment. You can leave the defaults or change to your preferences. You only need to complete the AWS settings. Go to https://raw.githubusercontent.com/AviatrixSystems/terraform-solutions/master/solutions/img/kickstart.png to view what is going to be launched. In the text editor, press :wq when done.\n'
    mcna_init
    mcna_aws_transit
    if [ $? != 0 ]; then
	echo "--> Failed to launch AWS transit, aborting." >&2
	return 1
    fi
fi

read -p $'\n\n--> Do you want to launch test EC2 instances in the AWS Spoke VPCs? (y/n)? ' answer
if [ "$answer" != "${answer#[Yy]}" ] ; then
    mcna_aws_test_instances
fi

read -p $'\n\n--> Do you want to launch the Aviatrix transit in Azure? (y/n)? ' answer
if [ "$answer" != "${answer#[Yy]}" ] ; then
    read -n 1 -r -s -p $'\n\n--> Now opening the settings file for the Azure deployment. You can leave the defaults or change to your preferences. You only need to complete the Azure settings. Go to https://raw.githubusercontent.com/AviatrixSystems/terraform-solutions/master/solutions/img/kickstart.png to view what is going to be launched. Perform the pre-requisites at https://docs.aviatrix.com/HowTos/Aviatrix_Account_Azure.html. Press any key to continue. In the text editor, press :wq when done.\n'
    mcna_init
    mcna_azure_transit
    if [ $? != 0 ]; then
	echo "--> Failed to launch Azure transit, aborting." >&2
	return 1
    fi
    azure=1
fi

if [ $azure ]; then
    read -p $'\n\n--> Do you want to build a transit peering between AWS and Azure? (y/n)? ' answer
    if [ "$answer" != "${answer#[Yy]}" ] ; then
	peering
	if [ $? != 0 ]; then
	    echo "--> Failed to build peering, aborting." >&2
	    return 1
	fi
    fi
fi

echo -e "\n--> Aviatrix Kickstart is done. Your controller IP is $CONTROLLER_PUBLIC_IP."
cd /root
