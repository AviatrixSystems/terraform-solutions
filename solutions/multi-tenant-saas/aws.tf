provider "aws" {
  profile = "dev-eu-west-1"
  region  = "eu-west-1"
}

### Create AWS Security Group for test instances, in every VPC.
resource "aws_security_group" "icmp_ssh" {
  for_each    = aviatrix_vpc.vpcs
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
  subnet_id                   = aviatrix_vpc.vpcs[each.value.vpc].subnets[3].subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.icmp_ssh[each.value.vpc].id]
  key_name                    = each.value.key
}

resource "aws_vpn_gateway" "vpn_gws" {
  for_each = var.test_vpn_gateways
  vpc_id   = aviatrix_vpc.vpcs[each.value.vpc].vpc_id
  tags = {
    Name = each.value.name
  }
}

resource "aws_customer_gateway" "cgws" {
  for_each = var.test_customer_gateways
  bgp_asn  = each.value.bgp_asn
  # IP address of the corresponding AVX S2C GW
  ip_address = aviatrix_gateway.customer_s2c_gws[each.value.avx_s2c_gw].eip
  type       = "ipsec.1"

  tags = {
    Name = each.value.name
  }
}

# For each VGW, create a Site-to-Site VPN connection to AVX S2C GW.
resource "aws_vpn_connection" "s2s_vpn_connections" {
  for_each            = var.test_vpn_gateways
  vpn_gateway_id      = aws_vpn_gateway.vpn_gws[each.key].id
  customer_gateway_id = aws_customer_gateway.cgws[each.key].id
  type                = "ipsec.1"
  static_routes_only  = true
}
