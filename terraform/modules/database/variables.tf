variable "region" {
  type        = string
  description = "azure region where the aks cluster must be created, this region should match where you have created the resource group, vnet and subnet"
}

variable "resource_group_name" {
  type        = string
  description = "azure resource group name where the aks cluster should be created"
}

variable "env" {
  type = string
}

variable "db_subnet_id" {
  type        = string
  description = "The db subnet, where is allocated the network rule"
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used the virtual network. You can supply more than one address space but for our module implementation we are limiting it to 1 address space only."
  default     = ["10.1.0.0/16"]
  validation {
    condition     = length(var.address_space) == 1
    error_message = "Only a single address space can be set. Please check your subnet address prefixes."
  }
}

variable "subnet_address_prefix" {
  type        = list(string)
  description = "The address prefixes to use for the subnet. Currently only a single address prefix can be set as the Multiple Subnet Address Prefixes Feature is not yet in public preview or general availability."
  validation {
    condition     = length(var.subnet_address_prefix) == 1
    error_message = "Only a single address prefix can be set. Please check your subnet address prefixes."
  }
}

variable "administrator_login" {
  type = string
}

variable "administrator_login_password" {
  type = string
}