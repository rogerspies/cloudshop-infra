resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.project_name}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.project_name}-aks"
  kubernetes_version  = "1.32.10"

  default_node_pool {
    name           = "workers"
    node_count     = 1
    vm_size        = "Standard_B2s_v2"
    vnet_subnet_id = var.subnet_id

    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  auto_scaler_profile {
    balance_similar_node_groups  = true
    max_graceful_termination_sec = 600
  }

  tags = {
    Name = "${var.project_name}-aks"
  }
}