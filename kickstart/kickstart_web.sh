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

#write IP's to sh file for use during launch transit etc
writekeys_controller_launch() {

  cd /root/
  echo "Into write keys "
  local AWS_ACCOUNT=$1
  local CONTROLLER_PRIVATE_IP=$2
  local CONTROLLER_PUBLIC_IP=$3
  local AVIATRIX_CONTROLLER_IP=$4

  echo "$AVIATRIX_CONTROLLER_IP"

  # Save variables to file
  typeset -p AWS_ACCOUNT CONTROLLER_PRIVATE_IP CONTROLLER_PUBLIC_IP AVIATRIX_CONTROLLER_IP >keys.sh

}

#write user credientials to sh file for use during launch transit etc
writekeys_controller_init() {

  cd /root/
  . keys.sh;

  echo "Into write keys 2"
  local AVIATRIX_EMAIL=$1
  local AVIATRIX_PASSWORD=$2
  local AVIATRIX_USERNAME=$3
  local KICKSTART_CONTROLLER_INIT_DONE=$4

  # Save variables to file
  typeset -p  AWS_ACCOUNT CONTROLLER_PRIVATE_IP CONTROLLER_PUBLIC_IP AVIATRIX_CONTROLLER_IP  AVIATRIX_EMAIL AVIATRIX_PASSWORD AVIATRIX_USERNAME KICKSTART_CONTROLLER_INIT_DONE >keys.sh
}

#test for key.sh data
check_data_test() {
    cd /root/
    . keys.sh # Load variables from file

    echo "test"
    echo "$AWS_ACCOUNT"
    printf 'AWS_ACCOUNT=%s\n' "$AWS_ACCOUNT"
    printf 'CONTROLLER_PRIVATE_IP=%s\n' "$CONTROLLER_PRIVATE_IP"
    printf 'CONTROLLER_PUBLIC_IP=%s\n' "$CONTROLLER_PUBLIC_IP"
    printf 'AVIATRIX_CONTROLLER_IP=%s\n' "$AVIATRIX_CONTROLLER_IP"

    printf 'AVIATRIX_EMAIL=%s\n'  "$AVIATRIX_EMAIL"
    printf 'AVIATRIX_PASSWORD=%s\n'  "$AVIATRIX_PASSWORD"
    printf 'AVIATRIX_USERNAME=%s\n'  "$AVIATRIX_USERNAME"
    printf 'KICKSTART_CONTROLLER_INIT_DONE=%s\n'  "$KICKSTART_CONTROLLER_INIT_DONE"

}

#aws set configuration api
aws_configure()
{
    #calling banner from first API
    banner_initilize

    if [ -d "/root/.aws" ]
    then
	echo "--> .aws exists, skipping aws configure."
	return 0
    fi
    echo "--> Going to get your AWS API access keys. They are required to launch the Aviatrix controller in AWS. They stay local to this container and are not shared. Access keys can be created in AWS console under Account -> My Security Credentials -> Access keys for CLI, SDK, & API access."
    # read -p '--> Enter AWS access key ID: ' key_id
    # read -p '--> Enter AWS secret access key: ' secret_key
    aws configure set aws_access_key_id $1
    aws configure set aws_secret_access_key $2
    echo "Aws credentials set"
}

#part of launch controller
record_controller_launch()
{
    echo
    email_support=$1
    echo $email_support
#    read -p '--> Enter email for Aviatrix support to reach out in case of issues (the email will be shared with Aviatrix): ' email_support
    d=$(date)
    payload="{\"controllerIP\":\"$CONTROLLER_PUBLIC_IP\", \"email\":\"$email_support\", \"timestamp\":\"$d\"}"
    curl -d "$payload" -H 'Content-Type: application/json' https://vyidaoc6pa.execute-api.us-west-2.amazonaws.com/v1/controller
}

#part of launch controller
generate_controller_ssh_key()
{
    if [ -z $KS_GOVCLOUD ]; then
	cd /root/controller
    else
	echo "--> AWS GovCloud SSH key generation"
	cd /root/controller-govcloud
    fi
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

#Subscriber service check
subscribe_service()
{
    if [ "$1" = "yes" ]; then
        if [ -z $KS_GOVCLOUD ]; then
           echo 'https://aws.amazon.com/marketplace/pp?sku=b03hn7ck7yp392plmk8bet56k'
        else
           echo 'https://aws.amazon.com/marketplace/pp?sku=b03hn7ck7yp392plmk8bet56k'
        fi
    else
       echo "No action performed"
    fi
}

#Launch controller main part
controller_launch()
{
    email_support=$1

    if [ -z $KS_GOVCLOUD ]; then
	cd /root/controller
    else
	echo "--> AWS GovCloud controller launch"
	cd /root/controller-govcloud
    fi

    generate_controller_ssh_key
    if [ $? -eq 0 ]; then
	echo "--> OK."
    else
	echo "--> Aborting." >&2
	return 1
    fi

#    if [ -z $KS_GOVCLOUD ]; then
#	read -n 1 -r -s -p $'\n--> Go to https://aws.amazon.com/marketplace/pp?sku=b03hn7ck7yp392plmk8bet56k and subscribe to the Aviatrix platform. Click on "Continue to subscribe", and accept the terms. Do NOT click on "Continue to Configuration". Press any key once you have subscribed.\n'
#    else
#	read -n 1 -r -s -p $'\n--> Go to https://aws.amazon.com/marketplace/pp?sku=b03hn7ck7yp392plmk8bet56k and subscribe to the Aviatrix platform. ACCESS THE MARKETPLACE FROM THE AWS ROOT ACCOUNT THAT IS IN CHARGE OF YOUR AWS GOVCLOUD ACCOUNT. Click on "Continue to subscribe", and accept the terms. Do NOT click on "Continue to Configuration". Press any key once you have subscribed.\n'
#    fi

    # Advanced mode. In GovCloud, always open it.
    if [ ! -z $KS_ADVANCED ] || [ ! -z $KS_GOVCLOUD ]; then
#	read -n 1 -r -s -p $'\n--> Opening controller settings file. Press any key to continue.\n'
	vim variables.tf
    fi

    echo -e "\n--> Now going to launch the controller. The public IP of the controller will be shared with Aviatrix for tracking purposes."
    # If not advanced and not GovCloud, then default mode.
    if [ -z $KS_ADVANCED ] && [ -z $KS_GOVCLOUD ]; then
	echo "--> The controller will be launched in us-east-1."
    fi

    read -n 1 -r -s -p $'--> To abort, close the window or press Ctrl-C. To continue, press any key.\n'
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

    if [ -z $KS_GOVCLOUD ]; then
	echo 'cd /root/controller' > $f
    else
	echo 'cd /root/controller-govcloud' > $f
    fi
    echo 'export AWS_ACCOUNT=$(terraform output aws_account)' >> $f
    echo 'export CONTROLLER_PRIVATE_IP=$(terraform output controller_private_ip)' >> $f
    echo 'export CONTROLLER_PUBLIC_IP=$(terraform output controller_public_ip)' >> $f
    echo 'export AVIATRIX_CONTROLLER_IP=$CONTROLLER_PUBLIC_IP' >> $f

    echo AWS_ACCOUNT: $AWS_ACCOUNT
    echo CONTROLLER_PRIVATE_IP: $CONTROLLER_PRIVATE_IP
    echo CONTROLLER_PUBLIC_IP: $CONTROLLER_PUBLIC_IP

    writekeys_controller_launch $AWS_ACCOUNT $CONTROLLER_PRIVATE_IP $CONTROLLER_PUBLIC_IP  $AVIATRIX_CONTROLLER_IP

    record_controller_launch $email_support

    echo -e "\n--> Waiting 5 minutes for the controller to come up... Do not access the controller yet."
    timer 300
    return 0
}

#controller init during launch
controller_init()
{
    email=$1
    password=$2
    confirm_password=$3

    echo "$email"
    echo "$password"
    echo "$confirm_password"

    if [ -z $KS_GOVCLOUD ]; then
    echo 'Into govt'
	cd /root/controller
    else
	echo 'Into else'
	echo "--> AWS GovCloud controller init"
	cd /root/controller-govcloud
    fi
#    echo
#    read -p '--> Enter email for controller password recovery: ' email
    export AVIATRIX_EMAIL=$email
    f=/root/.kickstart_restore
    echo "export AVIATRIX_EMAIL=$email" >> $f

#    while true; do
#	read -s -p "--> Enter new password: " password
#	echo
#	read -s -p "--> Confirm new password: " password2
#	echo
#	[ "$password" = "$confirm_password" ] && break
#	echo "--> Passwords don't match, please try again."
#    done
    export AVIATRIX_PASSWORD=$password
    str="export AVIATRIX_PASSWORD='$password'"
    echo $str >> $f

    export AVIATRIX_USERNAME=admin
    echo 'export AVIATRIX_USERNAME=admin' >> $f

    python3 controller_init.py
    if [ $? != 0 ]; then
	echo "--> Controller init failed"
	return 1
    fi

    export KICKSTART_CONTROLLER_INIT_DONE=true
    echo 'export KICKSTART_CONTROLLER_INIT_DONE=true' >> $f

    if [ ! -z $KS_GOVCLOUD ]; then
	cat /root/.eagle
    fi
    echo -e "\n--> Controller init has completed. Controller is ready. Do not manually change the controller version while Kickstart is running."

    writekeys_controller_init  $AVIATRIX_EMAIL $AVIATRIX_PASSWORD $AVIATRIX_USERNAME $KICKSTART_CONTROLLER_INIT_DONE
}

#mcna transit launch
mcna_aws_transit()
{
    cd /root/
    . keys.sh # Load variables from file

    echo "$AWS_ACCOUNT"
    echo "$CONTROLLER_PRIVATE_IP"
    echo "$CONTROLLER_PUBLIC_IP"
    echo "$AVIATRIX_CONTROLLER_IP"

    echo "$AVIATRIX_EMAIL"
    echo "$AVIATRIX_PASSWORD"
    echo "$AVIATRIX_USERNAME"
    echo "$KICKSTART_CONTROLLER_INIT_DONE"


    if [ -z $KS_GOVCLOUD ]; then
	cd /root/mcna
    else
	cd /root/mcna-govcloud
	echo "--> AWS GovCloud transit init"
    fi

    # Advanced mode.
    if [ ! -z $KS_ADVANCED ] || [ ! -z $KS_GOVCLOUD ]; then
#	read -n 1 -r -s -p $'\n--> Opening settings file. Press any key to continue.\n'
	vim variables.tf
    fi

    terraform init
    terraform apply -target=aviatrix_transit_gateway.aws_transit_gw -target=aviatrix_spoke_gateway.aws_spoke_gws -auto-approve
    return $?
}

#changing mcna variable file key here
input_aws_keypair()
{
    name=$1

    cd /root/
    . keys.sh # Load variables from file

    echo "$AWS_ACCOUNT"
    echo "$CONTROLLER_PRIVATE_IP"
    echo "$CONTROLLER_PUBLIC_IP"
    echo "$AVIATRIX_CONTROLLER_IP"

    echo "$AVIATRIX_EMAIL"
    echo "$AVIATRIX_PASSWORD"
    echo "$AVIATRIX_USERNAME"
    echo "$KICKSTART_CONTROLLER_INIT_DONE"

    if [ -z $KS_GOVCLOUD ]; then
	cd /root/mcna
    else
	cd /root/mcna-govcloud
	echo "--> AWS GovCloud EC2 test instances launch"
    fi


    if [ -z $KS_GOVCLOUD ]; then
	read -n 1 -r -s -p $'\n\n--> Opening the settings file. Make sure your key pair name is correct under aws_ec2_key_name. This is your own key pair, not Aviatrix keys for controller or gateways. Also make sure you are in the region where the Spoke gateways were launched (if using defaults, us-east-2). Press any key to continue.\n'
    else
	read -n 1 -r -s -p $'\n\n--> Opening the settings file. Make sure your key pair name is correct under aws_ec2_key_name. This is your own key pair, not Aviatrix keys for controller or gateways. Press any key to continue.\n'
    fi

    sed -i "s/variable \"aws_ec2_key_name\".*/variable \"aws_ec2_key_name\" { default = \"$name\" }/g" /root/mcna/variables.tf
#    sed -i "s/\"aws_ec2_key_name\" { default = \"nicolas\" }/\"aws_ec2_key_name\" { default = \"$name\" }/g" /root/mcna/variables.tf
    echo "done"
#    vim variables.tf
}

#creating test instance of aws
mcna_aws_test_instances()
{
    cd /root/
    . keys.sh # Load variables from file

    echo "$AWS_ACCOUNT"
    echo "$CONTROLLER_PRIVATE_IP"
    echo "$CONTROLLER_PUBLIC_IP"
    echo "$AVIATRIX_CONTROLLER_IP"

    echo "$AVIATRIX_EMAIL"
    echo "$AVIATRIX_PASSWORD"
    echo "$AVIATRIX_USERNAME"
    echo "$KICKSTART_CONTROLLER_INIT_DONE"


    name=$1
    if [ -z $KS_GOVCLOUD ]; then
	cd /root/mcna
    else
	cd /root/mcna-govcloud
	echo "--> AWS GovCloud EC2 test instances launch"
    fi

    input_aws_keypair $name
    echo "--> Launching instances now"
    terraform init
    terraform apply -target=aws_instance.test_instances -auto-approve
}

#launch azure transit
mcna_azure_transit()
{

    cd /root/mcna

    # Advanced mode.
    if [ ! -z $KS_ADVANCED ]; then
	read -n 1 -r -s -p $'\n--> Opening settings file. You can change the region and other settings like VNet and gateways. Press any key to continue.\n'
	vim variables.tf
    fi

    terraform init
    terraform apply -target=aviatrix_transit_gateway.azure_transit_gw -target=aviatrix_spoke_gateway.azure_spoke_gws -auto-approve
    return $?
}

#last step peering b/w azure and aws
peering()
{
    cd /root/mcna
    terraform init
    terraform apply -target=aviatrix_transit_gateway_peering.aws_azure -auto-approve
    return $?
}


custom_git()
{
    echo $KS_CUSTOM_GIT
    cd /root
    ghclone $KS_CUSTOM_GIT
    cd ${KS_CUSTOM_GIT##*/}
    source setup.sh
    return $?
}


banner_initilize()
{

    banner Aviatrix Kickstart
    cat /root/.plane
    if [ ! -z $KS_GOVCLOUD ]; then
        echo -e "--> GovCloud mode\n"
    fi
    if [ ! -z $KS_CUSTOM_GIT ]; then
        echo -e "--> Custom Git mode\n"
        custom_git
        return $?
    fi
}

#aws_configure

# If controller was already launched in this container, skip.
launch_controller()
{
    email=$1
    recovery_email=$2
    password=$3
    confirm_password=$4


    if [[ -v CONTROLLER_PUBLIC_IP ]]; then
        echo "--> Controller already launched, skipping."
    else
#        echo $1
#        if [[ $1 == yes ]] ; then
        controller_launch $recovery_email
        if [ $? != 0 ]; then
            echo "--> Controller launch failed, aborting."
            return 1
#        fi
        fi
    fi

    # If controller was already initialized in this container, skip.
    if [[ -v KICKSTART_CONTROLLER_INIT_DONE ]]; then
        echo "--> Controller already initialized, skipping."
    else
        controller_init $email $password $confirm_password
        if [ $? != 0 ]; then
        echo "--> Controller init failed, retrying."
        controller_init $email $password $confirm_password
        if [ $? != 0 ]; then
            echo "--> Controller init failed, exiting."
            return 1
        fi
        fi
    fi


}

#launch aciatrix transit api
launch_aws_transit()
{
    if [ ! -z $KS_ADVANCED ] || [ ! -z $KS_GOVCLOUD ]; then
        read -p $'\n\n--> Do you want to launch the Aviatrix transit in AWS? Go to https://raw.githubusercontent.com/AviatrixSystems/terraform-solutions/master/solutions/img/kickstart.png to view what is going to be launched. You can change the settings in the next step (y/n)? ' answer
    else
        read -p $'\n\n--> Do you want to launch the Aviatrix transit in AWS? Region will be us-east-2. Go to https://raw.githubusercontent.com/AviatrixSystems/terraform-solutions/master/solutions/img/kickstart.png to view what is going to be launched. (y/n)? ' answer
    fi
    if [ "$1" = "yes" ] ; then
        mcna_aws_transit
        if [ $? != 0 ]; then
        echo "--> Failed to launch AWS transit, aborting." >&2
        return 1
        fi
    fi
}

#aws spoke vpc initiate
aws_spoke_vpcs()
{
#    read -p $'\n\n--> Do you want to launch test EC2 instances in the AWS Spoke VPCs? (y/n)? ' answer
    if [ "$1" = "yes" ] ;  then
        mcna_aws_test_instances
    fi
}

#Azure transit launch first step
launch_azure_transit()
{
#    read -p $'\n\n--> Do you want to launch the Aviatrix transit in Azure? (y/n)? ' answer
#    if [ $1 = 'yes' ] ; then
#        read -n 1 -r -s -p $'\n\n--> Now opening the settings file for the Azure deployment. Your need to enter your Azure API keys. You can leave the rest to defaults or change to your preferences. You only need to complete the Azure settings. Perform the pre-requisites at https://docs.aviatrix.com/HowTos/Aviatrix_Account_Azure.html. Press any key to continue. In the text editor, press :wq when done.\n'

        cd /root/
        . keys.sh # Load variables from file

        echo "$AWS_ACCOUNT"
        echo "$CONTROLLER_PRIVATE_IP"
        echo "$CONTROLLER_PUBLIC_IP"
        echo "$AVIATRIX_CONTROLLER_IP"

        echo "$AVIATRIX_EMAIL"
        echo "$AVIATRIX_PASSWORD"
        echo "$AVIATRIX_USERNAME"
        echo "$KICKSTART_CONTROLLER_INIT_DONE"

        sed -i "s/\"azure_subscription_id\" { default = \"""\" }/\"azure_subscription_id\" { default = \"$1\" }/g" /root/mcna/variables.tf
        sed -i "s/\"azure_directory_id\" { default = \"""\" }/\"azure_directory_id\" { default = \"$2\" }/g" /root/mcna/variables.tf
        sed -i "s/\"azure_application_id\" { default = \"""\" }/\"azure_application_id\" { default = \"$3\" }/g" /root/mcna/variables.tf
        sed -i "s/\"azure_application_key\" { default = \"""\" }/\"azure_application_key\" { default = \"$4\" }/g" /root/mcna/variables.tf

#        vim /root/mcna/variables.tf
        mcna_azure_transit
        if [ $? != 0 ]; then
        echo "--> Failed to launch Azure transit, aborting." >&2
        return 1
        fi
        azure=1

#    fi
}

#peering transit aws,azure initiated here
transit_peering_aws_azure()
{
#if [ $azure ]; then
#    read -p $'\n\n--> Do you want to build a transit peering between AWS and Azure? (y/n)? ' answer
#    if [ "$answer" != "${answer#[Yy]}" ] ; then
    if [ "$1" = "yes" ] ; then
	peering
	if [ $? != 0 ]; then
	    echo "--> Failed to build peering, aborting." >&2
	    return 1
	fi
    fi
#fi
}

#launch public ip
get_public_ip()
{
    cd /root/
        . keys.sh # Load variables from file

    export $CONTROLLER_PUBLIC_IP
    echo "$CONTROLLER_PUBLIC_IP"

}

#destroy terraform here
delete_terraform()
{
    cd /root/
    . keys.sh # Load variables from file

    echo "$AWS_ACCOUNT"
    echo "$CONTROLLER_PRIVATE_IP"
    echo "$CONTROLLER_PUBLIC_IP"
    echo "$AVIATRIX_CONTROLLER_IP"

    echo "$AVIATRIX_EMAIL"
    echo "$AVIATRIX_PASSWORD"
    echo "$AVIATRIX_USERNAME"
    echo "$KICKSTART_CONTROLLER_INIT_DONE"

    terraform init
    cd /root/mcna
    terraform destroy -auto-approve
    cd /root/controller
    terraform destroy -auto-approve
    echo "Done"
}
