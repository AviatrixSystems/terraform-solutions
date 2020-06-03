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

variable oci_region {
  type    = string
  default = "us-ashburn-1"
}

variable oci_account_name {
  type    = string
  default = ""
}

#variable vcn_cidr {
#  type    = string
#  default = ""
#}

variable vcn_public_subnet_cidr {
  type    = string
  default = ""
}

variable oci_vcn_name {
  type    = string
  default = ""
}

variable vpn_gw_name {
  type    = string
  default = ""
}

variable gw_size {
  type    = string
  default = "VM.Standard2.2"
}

variable "vpn_users" {
  description = "VPN User Parameters: user_name, user_email"
  type = map(object({
    user_name        = string
    user_email       = string
  }))
}