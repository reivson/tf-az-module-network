terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Hub Network
module "hub_network" {
  source = "../.."

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vnet_name           = var.hub_vnet_name
  vnet_address_space  = var.hub_vnet_address_space

  subnets = {
    "subnet-firewall" = {
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Storage"]
    }
    "subnet-shared" = {
      address_prefixes  = ["10.0.2.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }
  }

  network_security_groups = {
    "nsg-hub-shared" = {
      security_rules = [
        {
          name                       = "allow-spoke-traffic"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "10.1.0.0/16"
          destination_address_prefix = "*"
        },
        {
          name                       = "allow-management"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_ranges    = ["22", "3389"]
          source_address_prefix      = var.management_ip
          destination_address_prefix = "*"
        }
      ]
      associated_subnets = ["subnet-shared"]
    }
  }

  tags = merge(var.tags, {
    NetworkRole = "Hub"
  })
}

# Spoke Network
module "spoke_network" {
  source = "../.."

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vnet_name           = var.spoke_vnet_name
  vnet_address_space  = var.spoke_vnet_address_space

  subnets = {
    "subnet-web" = {
      address_prefixes  = ["10.1.1.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Web"]
    }
    "subnet-app" = {
      address_prefixes  = ["10.1.2.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
    }
  }

  # Peering para o Hub
  peering_connections = {
    "peer-spoke-to-hub" = {
      remote_virtual_network_id    = module.hub_network.vnet_id
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
  }

  network_security_groups = {
    "nsg-spoke-web" = {
      security_rules = [
        {
          name                       = "allow-http"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "allow-https"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "allow-hub-traffic"
          priority                   = 120
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "10.0.0.0/16"
          destination_address_prefix = "*"
        }
      ]
      associated_subnets = ["subnet-web"]
    }
    "nsg-spoke-app" = {
      security_rules = [
        {
          name                       = "allow-web-to-app"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "8080"
          source_address_prefix      = "10.1.1.0/24"
          destination_address_prefix = "*"
        },
        {
          name                       = "allow-hub-traffic"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "10.0.0.0/16"
          destination_address_prefix = "*"
        }
      ]
      associated_subnets = ["subnet-app"]
    }
  }

  # Route Table para rotear tráfego através do Hub
  route_tables = {
    "rt-spoke-to-hub" = {
      disable_bgp_route_propagation = false
      routes = [
        {
          name                   = "route-to-internet-via-hub"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.1.4" # IP do firewall no hub
        }
      ]
      associated_subnets = ["subnet-web", "subnet-app"]
    }
  }

  tags = merge(var.tags, {
    NetworkRole = "Spoke"
  })
}

# Peering reverso - Hub para Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke"
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = module.hub_network.vnet_name
  remote_virtual_network_id = module.spoke_network.vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}
