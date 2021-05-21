terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.42.0"
    }
    http = {
      source = "hashicorp/http"
    }
  }
  required_version = ">= 0.13"
}
