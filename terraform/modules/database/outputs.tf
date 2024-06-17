output "db_host" {
  value = azurerm_mariadb_server.main.fqdn
}