provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg" {
  name     = "abc-demo-rg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "abc-demo-k8s"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "abc-demo-k8s"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "development"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
  sensitive = true
}