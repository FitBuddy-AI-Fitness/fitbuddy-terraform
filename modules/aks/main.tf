# User Assigned Identity for Workload Identity
resource "azurerm_user_assigned_identity" "aks_wi" {
  name                = "uami-fitbuddy-workload"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster-belgium"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "fitbuddy-aks-belgium"
  sku_tier            = "Free"
  tags                = var.tags

  default_node_pool {
    name                = "default"
    vm_size             = "Standard_D2ads_v6"
    vnet_subnet_id      = var.vnet_subnet_id
    type                = "VirtualMachineScaleSets"
    zones               = ["2", "3"]
    enable_auto_scaling = true
    node_count          = 1
    min_count           = 1
    max_count           = 2
  }

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}

# Removed ACR Pull Role Assignment due to ABAC Condition limitations.
# The user will attach ACR manually via Azure CLI later if needed.

# Federated Identity Credential for Production Namespace
resource "azurerm_federated_identity_credential" "fic_prod" {
  name                = "fic-fitbuddy-prod"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aks_wi.id
  subject             = "system:serviceaccount:production:fitbuddy-sa"
}

# Federated Identity Credential for Dev Namespace
resource "azurerm_federated_identity_credential" "fic_dev" {
  name                = "fic-fitbuddy-dev"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aks_wi.id
  subject             = "system:serviceaccount:dev:fitbuddy-sa"
}
