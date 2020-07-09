variable "region" { default = "us-east-1" }
variable "az" { default = "us-east-1a" }

# VPC CIDR and subnet for the controller.
variable "vpc_cidr" { default = "10.255.0.0/20" }
variable "vpc_subnet" { default = "10.255.0.0/28" }
