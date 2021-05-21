terraform {
  required_providers {
    aviatrix = {
      # Make sure to keep the version up to date with the controller version.
      # https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/guides/release-compatibility.
      source  = "aviatrixsystems/aviatrix"
      version = "~> 2.18.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.42.0"
    }
  }
  required_version = ">= 0.13"
}
