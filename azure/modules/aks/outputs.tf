output "cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "cluster_endpoint" {
  value = azurerm_kubernetes_cluster.main.fqdn
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive = true
}