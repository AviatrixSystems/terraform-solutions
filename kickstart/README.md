# Aviatrix Kickstart

## Summary
This solution deploys an Aviatrix controller and an Aviatrix transit architecture in AWS and in Azure.

<img alt="kickstart" src="https://github.com/AviatrixSystems/terraform-solutions/raw/master/solutions/img/kickstart.png">

## Instructions
Install Docker if you don't already have it: https://docs.docker.com/get-docker/.

Start the container:
```docker run -it aviatrix/automation bash```

Launch Aviatrix Kickstart:
```source ~/terraform-solutions/kickstart/kickstart.sh```

And follow the instructions.

To remove the transit deployment:
```cd ~/terraform-solutions/kickstart/mcna && terraform destroy```

To remove the controller:
```cd ~/terraform-solutions/kickstart/controller && terraform destroy```
