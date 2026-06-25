resource "azurerm_cosmosdb_account" "db" {
  name                = "cosmos-fitbuddy-eus2"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "MongoDB"
  tags                = var.tags

  capacity {
    total_throughput_limit = 4000
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  geo_location {
    location          = "westeurope"
    failover_priority = 1
  }

  consistency_policy {
    consistency_level = "Session"
  }

  public_network_access_enabled = false
}

resource "azurerm_cosmosdb_mongo_database" "mongodb" {
  name                = "fitbuddy-db"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.db.name
  throughput          = 400
}

# Private Endpoint
resource "azurerm_private_endpoint" "pe" {
  name                = "pe-cosmosdb"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-cosmosdb"
    private_connection_resource_id = azurerm_cosmosdb_account.db.id
    is_manual_connection           = false
    subresource_names              = ["MongoDB"]
  }

  private_dns_zone_group {
    name                 = "pdzg-cosmos"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmos.id]
  }
}

resource "azurerm_private_dns_zone" "cosmos" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "vnet-link-cosmos"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos.name
  virtual_network_id    = var.vnet_id
}

