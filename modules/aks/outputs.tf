output "cluster_name" { value = azurerm_kubernetes_cluster.aks.name }
output "cluster_endpoint" { value = azurerm_kubernetes_cluster.aks.kube_config.0.host }
output "oidc_issuer_url" { value = azurerm_kubernetes_cluster.aks.oidc_issuer_url }
output "workload_identity_client_id" { value = azurerm_user_assigned_identity.aks_wi.client_id } 
