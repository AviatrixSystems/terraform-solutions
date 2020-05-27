# Aviatrix Azure Terraform SP Bootstrap

This script creates an Azure service principal and outputs an .env file that can be sourced for provisioning an Aviatrix Controller in Azure.


## Dependencies

Install the tools you need and login to Azure; this takes a minute or two. Use chocolatey on windows..

- **homebrew**  ```/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"```

- **jq**   ```brew install jq```

- **terraform** ```brew install terraform```

- **azure cli**  ```brew update && brew install azure-cli```

- ```az login``` This command will open your default browser and load an Azure sign-in page.

## Getting started

1. Run a simple test to show your Azure Subscription ID  ```export SUB_ID=`az account show | jq -r '.id'` && echo "My Azure Subscription ID is $SUB_ID"```

2. Run the script ```./avx_tf_sp.sh```

3. Source the **avx_tf_sp.env** file created to set the ARM env variables needed by the azurerm terraform provider ```source avx_tf_sp.env```

Your environment will look similar to this:

```
$ env | grep ARM
ARM_CLIENT_ID=nnnnnnn-f2e7-4690-a64d-nnnnnn
ARM_TENANT_ID=c818a18b-5ee5-4b80-812f-nnnnnnnn
ARM_CLIENT_SECRET=50737fec-8bff-4859-866e-nnnnnnnn
ARM_SUBSCRIPTION_ID=nnnnnn-a8c3-44dd-af11-nnnnnnnn
```

You will now have everything you need to provision Aviatrix Controller in Azure using terraform.




