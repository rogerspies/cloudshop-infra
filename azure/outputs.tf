output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "aks_cluster_name" {
  value = module.aks.cluster_name
}

output "vm_public_ip" {
  value = module.vm.public_ip
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "postgres_endpoint" {
  value     = module.postgres.postgres_endpoint
  sensitive = true
}