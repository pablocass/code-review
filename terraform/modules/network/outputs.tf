output "az_rg_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.az_rg.id
}

output "az_rg_name" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.az_rg.name
}

output "az_vnet_id" {
  description = "The ID of the vnet"
  value       = azurerm_virtual_network.az_vnet.id
}

output "az_subnet_id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.az_subnet.id
}

output "db_subnet_address_prefix" {
  description = "The database subnet prefix"
  value = azurerm_subnet.db_subnet.address_prefixes[0]
}

output "db_subnet_id" {
  description = "The database subnet ID"
  value = azurerm_subnet.db_subnet.id
}