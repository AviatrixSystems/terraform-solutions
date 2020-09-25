variable "region" { default = "us-gov-west-1" }
variable "az" { default = "us-gov-west-1c" }

# VPC CIDR and subnet for the controller.
variable "vpc_cidr" { default = "10.255.0.0/20" }
variable "vpc_subnet" { default = "10.255.0.0/28" }
