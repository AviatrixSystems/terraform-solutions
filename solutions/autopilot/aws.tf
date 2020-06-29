provider "aws" {
  profile = "dev-eu-west-1"
  region  = var.aws_region
}

### Create AWS Security Group for test instances, in every VPC.
resource "aws_security_group" "icmp_ssh" {
  for_each = aviatrix_vpc.aws_vpcs

  name        = "ICMP-SSH-SG"
  description = "ICMP-SSH-SG"
  vpc_id      = each.value.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ICMP-SSH-SG"
  }
}

### Create test instances.
resource "aws_instance" "test_instances" {
  for_each = var.test_ec2_instances

  tags = {
    Name = each.value.name
  }
  ami           = each.value.ami
  instance_type = each.value.size
  # Public subnet.
  subnet_id                   = aviatrix_vpc.aws_vpcs[each.value.vpc].subnets[3].subnet_id
  private_ip                  = each.value.private_ip
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.icmp_ssh[each.value.vpc].id]
  key_name                    = each.value.key
}
