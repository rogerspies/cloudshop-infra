resource "azurerm_postgresql_flexible_server" "main" {
  name                   = "${var.project_name}-postgres"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "16"
  administrator_login    = "postgres"
  administrator_password = var.db_password
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  zone                   = "1"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  tags = {
    Name = "${var.project_name}-postgres"
  }
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "cloudshop"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}