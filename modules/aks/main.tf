# User Assigned Identity for Workload Identity
resource "azurerm_user_assigned_identity" "aks_wi" {
  name                = "uami-fitbuddy-workload"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# AKS Cluster (Bare Minimum for Debugging)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster-eus2"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "fitbuddy-aks-eus2"
  tags                = var.tags

  default_node_pool {
    name       = "default"
    vm_size    = "Standard_D2s_v3"
    node_count = 1
  }

  identity {
    type = "SystemAssigned"
  }
}

# User node pool temporarily removed for debugging
# Federated identity credentials temporarily removed for debugging
