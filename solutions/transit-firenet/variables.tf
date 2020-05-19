variable "vpc_count" {
  default = 2
}

variable "username" {
  type    = string
  default = ""
}

variable "password" {
  type    = string
  default = ""
}

variable "controller_ip" {
  type    = string
  default = ""
}

variable "hpe" {
  default = false
}

variable "region" {
  default = "us-east-2"
}

variable "key_name" {
  default = "avtx-key"
}

variable account_name {
  default = ""
}

variable "avx_transit_gw" {
  default = "transit-gw"
}
variable avx_gw_size {
  default = "c5.xlarge"
}

variable firewall_size {
  default = "c5.xlarge"
}

variable fw_image {
  default ="Check Point CloudGuard IaaS Next-Gen Firewall w. Threat Prevention & SandBlast BYOL"
}       