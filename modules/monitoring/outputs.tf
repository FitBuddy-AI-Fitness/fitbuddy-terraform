output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}

output "grafana_id" {
  value = azurerm_dashboard_grafana.grafana.id
}
