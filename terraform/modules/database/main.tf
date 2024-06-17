# Azure Maria Server
resource "azurerm_mariadb_server" "main" {
  name = "database"
  location = var.region
  resource_group_name = var.resource_group_name

  administrator_login = var.administrator_login
  administrator_login_password = var.administrator_login_password

  sku_name = "B_Gen5_2"
  storage_mb = 5120
  version = "10.2"

  auto_grow_enabled = true
  backup_retention_days = 7
  geo_redundant_backup_enabled = false
  public_network_access_enabled = false
  ssl_enforcement_enabled = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_mariadb_configuration" "example" {
  name                = "interactive_timeout"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mariadb_server.main.name
  value               = "600"
}

# Azure Maria Database
resource "azurerm_mariadb_database" "app" {
  name = "app"
  resource_group_name = var.resource_group_name
  server_name = azurerm_mariadb_server.main.name
  charset = "utf8mb4"
  collation = "utf8mb4_unicode_520_ci"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_mariadb_virtual_network_rule" "example" {
  name                = "database-vnet-rule"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mariadb_server.main.name
  subnet_id           = var.db_subnet_id
}

resource "azurerm_mariadb_firewall_rule" "example" {
  name                = "database-rule"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mariadb_server.main.name
  start_ip_address    = var.subnet_address_prefix
  end_ip_address      = var.subnet_address_prefix
}