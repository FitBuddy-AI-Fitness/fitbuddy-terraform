output "aks_cluster_name" {
  description = "The name of the AKS Cluster"
  value       = module.aks.cluster_name
}

output "aks_cluster_endpoint" {
  description = "The Kubernetes API server endpoint"
  value       = module.aks.cluster_endpoint
}

output "cosmosdb_connection_string" {
  description = "Connection string for CosmosDB"
  value       = module.database.connection_string
  sensitive   = true
}

output "estimated_monthly_cost" {
  description = "Cloud cost analysis (Estimated)"
  value       = "Estimated Monthly Cost: AKS Standard ($0.10/hr/node * 3 nodes = ~/mo) + CosmosDB Serverless (~$50/mo) + App Gateway WAF v2 (~$225/mo) = ~$491/month"
}
