provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

### Create AWS Security Group for test instances, in every Spoke VPC.
resource "aws_security_group" "icmp_ssh" {
  for_each = aviatrix_vpc.aws_spoke_vpcs

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

### Get the latest AMI of Amazon Linux.
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

### Test EC2 instances.
resource "aws_instance" "test_instances" {
  for_each = var.test_ec2_instances

  tags = {
    Name = each.value.name
  }
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = each.value.size
  # Public subnet.
  subnet_id                   = aviatrix_vpc.aws_spoke_vpcs[each.value.vpc].subnets[length(data.aws_availability_zones.az_available.names)].subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.icmp_ssh[each.value.vpc].id]
  key_name                    = var.aws_ec2_key_name
  depends_on                  = [aws_security_group.icmp_ssh]
}

output "test_ec2_instances_public_ips" {
  value = {
    for instance in aws_instance.test_instances :
    instance.tags.Name => instance.public_ip
  }
}

output "test_ec2_instances_private_ips" {
  value = {
    for instance in aws_instance.test_instances :
    instance.tags.Name => instance.private_ip
  }
}
