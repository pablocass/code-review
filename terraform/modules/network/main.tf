resource "azurerm_virtual_network" "az_vnet" {
  name                = "${var.vnet_name}_${var.env}"
  location            = var.region
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.az_vnet.name
  address_prefixes     = var.subnet_address_prefix
  service_endpoints    = var.service_endpoints
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "database_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.az_vnet.name
  address_prefixes     = var.subnet_address_prefix
  service_endpoints    = var.service_endpoints
}

resource "azurerm_network_security_group" "aks" {
  name                = "aks-sg-gp"
  location            = var.region
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

resource "azurerm_network_security_group" "db" {
  name                = "database-sg-gp"
  location            = var.region
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowDBAccess"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.db_port
    source_address_prefix      = azurerm_subnet.aks_subnet.address_prefixes[0]
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.db.id
}