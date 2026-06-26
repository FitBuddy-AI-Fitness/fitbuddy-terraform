# User Assigned Identity for Workload Identity
resource "azurerm_user_assigned_identity" "aks_wi" {
  name                = "uami-fitbuddy-workload"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster-eus2"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix              = "fitbuddy-aks-eus2"
  tags                    = var.tags
  private_cluster_enabled = false

  default_node_pool {
    name                = "default"
    vm_size             = "Standard_D2ads_v6"
    vnet_subnet_id      = var.vnet_subnet_id
    type                = "VirtualMachineScaleSets"
    auto_scaling_enabled = true
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
    service_cidr      = "172.16.0.0/16"
    dns_service_ip    = "172.16.0.10"
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D2ads_v6"
  vnet_subnet_id        = var.vnet_subnet_id
  auto_scaling_enabled  = true
  min_count             = 1
  max_count             = 2
  node_taints           = ["workload=app:NoSchedule"]
  tags                  = var.tags
}

# ACR Pull Role Assignment
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

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
