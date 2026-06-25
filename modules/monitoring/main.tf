resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-fitbuddy-belgium"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_monitor_workspace" "prom" { 
  name                = "prom-fitbuddy-belgium"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_dashboard_grafana" "grafana" {
  name                              = "grafana-fitbuddy-bel"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true
  grafana_major_version             = ["9", "10"]
  tags                              = var.tags

  identity {
    type = "SystemAssigned"
  }
}
