output "hub_vnet_id" { value = azurerm_virtual_network.hub.id }
output "spoke_vnet_id" { value = azurerm_virtual_network.spoke.id }
output "aks_subnet_id" { value = azurerm_subnet.aks.id }
output "pe_subnet_id" { value = azurerm_subnet.private_endpoints.id }
output "appgw_public_ip" { value = azurerm_public_ip.appgw.ip_address }
