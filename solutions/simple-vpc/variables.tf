variable "aws_account_name" { default = "aws-dev" }

variable "aws_vpc" {
  default = {
    name       = "AWS-UE2-Test-VPC"
    region     = "us-east-2"
    cidr       = "10.0.0.0/16"
  }
}
