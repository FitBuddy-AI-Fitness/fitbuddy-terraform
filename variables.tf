variable "resource_group_name" {
  description = "Name of the pre-existing resource group"
  type        = string
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}

variable "hub_vnet_cidr" {
  description = "CIDR block for Hub VNet"
  type        = string
}

variable "spoke_vnet_cidr" {
  description = "CIDR block for Spoke VNet"
  type        = string
}

variable "aks_node_count" {
  description = "Number of nodes in AKS cluster"
  type        = number
}
