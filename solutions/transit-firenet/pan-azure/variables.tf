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

variable "ha_gw" {
  type    = bool
  default = false
}

variable "firewall_size" {
  type    = string
  default = "Standard_D3_v2"
}

variable "region" {
  default = "East US"
}

variable "azure_account_name" {
  default = ""
}

variable "transit1_cidr" {
  default = "10.1.0.0/20"
}

variable "spoke1_cidr" {
  default = "10.2.0.0/20"
}

variable "spoke2_cidr" {
  default = "10.3.0.0/20"
}

variable "azure_gw_size" {
  default = "Standard_B2ms"
}

variable "firewall_image" {
  default = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
}

variable "firewall_image_version" {
  default = "9.1.0"
}

variable "insane_mode" {
  description = "Set to true to enable Aviatrix high performance encryption."
  type        = bool
  default     = false
}

