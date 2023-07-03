#
# Custom User Settings
#

# OpenStack Availability Zone
variable "zone" {
  type        = string
  description = ""
  default = "eu01-m"
}

# OpenStack VM Flavor
variable "flavor" {
  type        = string
  description = ""
  default = "c1.2"
}

# ACL to Access IPsec Ports
variable "any" {
  type = map(string)
  default = {
    cidr  = "0.0.0.0/0"
  }
}

# ACL to Access VPN Appliance per SSH
variable "ssh" {
  type = map(string)
  default = {
    cidr  = "0.0.0.0/0"
  }
}

############################################

#
# System Settings (do not edit)
#

# OpenStack UAT Username
variable "USERNAME" {
  type        = string
  description = ""
}

# OpenStack Project ID
variable "TENANTID" {
  type        = string
  description = ""
}

# OpenStack UAT Password
variable "PASSWORD" {
  type        = string
  description = ""
}

# SSH Key to Access VPN Appliance
variable "SSH_KEY" {
  type      = string
  description = ""
  default = ""
}

# VPN Appliance Version
variable "VERSION" {
  type        = string
  description = ""
}

# Remote Subnet to configure Routers
variable "REMOTE_SUBNET" {
  type        = string
  description = ""
}

# Local VPC Subnet to create OpenStack Network
variable "LOCAL_SUBNET" {
  type        = string
  description = ""
  default = "10.0.0.0/24"
}

# VPN Appliance Version Branch (dev/prod)
variable "STAGE" {
  type        = string
  description = ""
  default = "prod"
}

# Config Injection / Custom User Scripts
data "local_file" "vpn_user_data" {
  filename = "deployment.sh"
}