resource "azurerm_servicebus_namespace" "sb" {
  name                = "sb-fitbuddy-belgium"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags
  
  # The user explicitly requested to make Service Bus PUBLIC
  public_network_access_enabled = true
}

resource "azurerm_servicebus_queue" "workout_queue" {
  name         = "workout-events"
  namespace_id = azurerm_servicebus_namespace.sb.id
}

resource "azurerm_servicebus_queue" "diet_queue" {
  name         = "diet-events"
  namespace_id = azurerm_servicebus_namespace.sb.id
}

