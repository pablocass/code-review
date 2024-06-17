locals {
  env = "dev"
  location = "useast1"
}

resource "azurerm_resource_group" "code-review" {
  name = "code-review"
  location = local.location
}


module "network" {
  source = "../../modules/network"
  resource_group_name = azurerm_resource_group.code-review.name
  region = azurerm_resource_group.code-review.location
  env = local.env

  vnet_name = "code-review"
  db_port = "3306"
  address_space = ["10.1.0.0/16"]
  subnet_address_prefix = ["10.1.0.0/16"]
  service_endpoints = []
}

module "database" {
  source = "../../modules/database"
  resource_group_name = azurerm_resource_group.code-review.name
  region = azurerm_resource_group.code-review.location
  env = local.env

  db_subnet_id = module.network.db_subnet_id
  address_space = []
  subnet_address_prefix = module.network.db_subnet_address_prefix
  administrator_login = ""
  administrator_login_password = ""
}

module "aks" {
  source = "../../modules/aks"
  resource_group_name = azurerm_resource_group.code-review.name
  region = azurerm_resource_group.code-review.location
  env = local.env

  cluster_name = "code-review"
  k8s_version = "1.30"
  dns_prefix = "platformwale"
  az_subnet_id = module.network.az_subnet_id
  network_plugin = "azure"

  nodepools = {
    worker = {
        name = "worker"
        zones = [1, 2, 3]
        vm_size = "Standard_D2_v2"
        min_count = 3
        max_count = 10
        enable_auto_scaling = true
        enable_node_public_ip = true
    }
  }
}