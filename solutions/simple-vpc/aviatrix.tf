provider "aviatrix" {
  # Make sure to keep the version up to date with the controller version.
  # https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/guides/release-compatibility.
  version = "~> 2.16.3"
}

resource "aviatrix_vpc" "vpc" {
  cloud_type           = 1 # AWS
  account_name         = var.aws_account_name
  name                 = var.aws_vpc.name
  region               = var.aws_vpc.region
  cidr                 = var.aws_vpc.cidr
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
}
