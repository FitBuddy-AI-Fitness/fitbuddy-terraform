output "servicebus_namespace" { value = azurerm_servicebus_namespace.sb.name }
output "servicebus_connection_string" { 
  value     = azurerm_servicebus_namespace.sb.default_primary_connection_string
  sensitive = true 
}
