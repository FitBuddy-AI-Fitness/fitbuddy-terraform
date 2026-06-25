resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Azure Cognitive Services (AI Foundry / OpenAI)
resource "azurerm_cognitive_account" "openai" {
  name                  = "cog-fitbuddy-v2-${random_string.suffix.result}"
  location              = "westeurope"
  resource_group_name   = var.resource_group_name
  kind                  = "OpenAI"
  sku_name              = "S0"
  tags                  = var.tags
  public_network_access_enabled = false
  custom_subdomain_name = "cog-fitbuddy-v2-${random_string.suffix.result}"
}

resource "azurerm_private_endpoint" "pe_openai" {
  name                = "pe-openai"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-openai"
    private_connection_resource_id = azurerm_cognitive_account.openai.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name                 = "pdzg-openai"
    private_dns_zone_ids = [azurerm_private_dns_zone.openai.id]
  }
}

resource "azurerm_private_dns_zone" "openai" {
  name                = "privatelink.openai.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "openai_vnet_link" {
  name                  = "vnet-link-openai"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.openai.name
  virtual_network_id    = var.vnet_id
}

# Azure AI Search (Cognitive Search)
resource "azurerm_search_service" "search" {
  name                = "srch-fitbuddy-v2-${random_string.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = "westeurope"
  sku                 = "standard"
  tags                = var.tags
  public_network_access_enabled = false
}

resource "azurerm_private_endpoint" "pe_search" {
  name                = "pe-search"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-search"
    private_connection_resource_id = azurerm_search_service.search.id
    is_manual_connection           = false
    subresource_names              = ["searchService"]
  }

  private_dns_zone_group {
    name                 = "pdzg-search"
    private_dns_zone_ids = [azurerm_private_dns_zone.search.id]
  }
}

resource "azurerm_private_dns_zone" "search" {
  name                = "privatelink.search.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "search_vnet_link" {
  name                  = "vnet-link-search"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.search.name
  virtual_network_id    = var.vnet_id
}

