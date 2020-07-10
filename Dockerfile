FROM phusion/baseimage:0.10.1

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Dependencies.
RUN	apt-get -y update && \
	apt-get -y install wget unzip emacs git python3-pip

# Awscli install.
RUN	wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -P /tmp
RUN	unzip /tmp/awscli-exe-linux-x86_64.zip -d /tmp
RUN	/tmp/aws/install

# Python libraries.
RUN	pip3 install requests urllib3

# Terraform install.
RUN	wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip -P /tmp
RUN	unzip /tmp/terraform_0.12.24_linux_amd64.zip -d /usr/local/sbin/

# Terraform Aviatrix solutions.
RUN	mkdir /root/terraform-solutions
ADD     autopilot /root/terraform-solutions/autopilot
ADD	controller-launch /root/terraform-solutions
ADD	solutions /root/terraform-solutions

# Misc. configuration
RUN	mkdir -p /root/.emacs.d/lisp
ADD	config/terraform-mode.el /root/.emacs.d/lisp
ADD	config/hcl-mode.el /root/.emacs.d/lisp
ADD	config/dotemacs /root/.emacs

# Clean up when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
