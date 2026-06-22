data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

locals {
  common_tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

module "vnet" {
  source = "./modules/vnet"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  hub_vnet_cidr       = var.hub_vnet_cidr
  spoke_vnet_cidr     = var.spoke_vnet_cidr
  tags                = local.common_tags
}

module "aks" {
  source              = "./modules/aks"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  vnet_subnet_id      = module.vnet.aks_subnet_id
  node_count          = var.aks_node_count
  acr_id              = module.storage.acr_id
  tags                = local.common_tags
}

module "database" {
  source                     = "./modules/database"
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = var.location
  private_endpoint_subnet_id = module.vnet.pe_subnet_id
  vnet_id                    = module.vnet.spoke_vnet_id
  tags                       = local.common_tags
}

module "storage" {
  source                     = "./modules/storage"
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = var.location
  private_endpoint_subnet_id = module.vnet.pe_subnet_id
  vnet_id                    = module.vnet.spoke_vnet_id
  tags                       = local.common_tags
}

module "security" {
  source                     = "./modules/security"
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = var.location
  private_endpoint_subnet_id = module.vnet.pe_subnet_id
  vnet_id                    = module.vnet.spoke_vnet_id
  tags                       = local.common_tags
}

module "messaging" {
  source              = "./modules/messaging"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  tags                = local.common_tags
}

module "ai" {
  source                     = "./modules/ai"
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = var.location
  private_endpoint_subnet_id = module.vnet.pe_subnet_id
  vnet_id                    = module.vnet.spoke_vnet_id
  tags                       = local.common_tags
}

