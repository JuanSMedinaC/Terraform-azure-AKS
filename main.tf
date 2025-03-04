provider "azurerm" {
  subscription_id = "<replace-with-your-subscription-id>"
  features {}
}
resource "azurerm_resource_group" "jm-first-rg" {
  name     = "jm-plataformas-first-rg"
  location = "East Us"
}

resource "azurerm_kubernetes_cluster" "jmaks" {
  name                = "jm-plataformas-aks1"
  location            = azurerm_resource_group.jm-first-rg.location
  resource_group_name = azurerm_resource_group.jm-first-rg.name
  dns_prefix          = "jmpaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production-jm-plataformas"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.jmaks.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.jmaks.kube_config_raw

  sensitive = true
}