terraform {
  required_version = ">= 1.2"
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

# Network Module - Configuração Completa
module "network" {
  source = "../.."

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  dns_servers         = var.dns_servers

  # Subnets com diferentes configurações
  subnets = {
    "subnet-web" = {
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }
    "subnet-app" = {
      address_prefixes  = ["10.0.2.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
    }
    "subnet-database" = {
      address_prefixes                              = ["10.0.3.0/24"]
      service_endpoints                             = ["Microsoft.Sql", "Microsoft.Storage"]
      private_endpoint_network_policies_enabled     = false
      private_link_service_network_policies_enabled = false
    }
    "subnet-sql-mi" = {
      address_prefixes = ["10.0.10.0/24"]
      delegation = {
        name = "sql-delegation"
        service_delegation = {
          name = "Microsoft.Sql/managedInstances"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action",
            "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
            "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
          ]
        }
      }
    }
  }

  # NAT Gateway
  nat_gateway = {
    enabled                 = true
    name                    = "nat-gw-${var.vnet_name}"
    idle_timeout_in_minutes = 10
    public_ip_count         = 2
    associated_subnets      = ["subnet-web", "subnet-app"]
  }

  # Network Security Groups
  network_security_groups = {
    "nsg-web" = {
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
          name                       = "allow-ssh"
          priority                   = 120
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = "10.0.0.0/16"
          destination_address_prefix = "*"
        }
      ]
      associated_subnets = ["subnet-web"]
    }
    "nsg-app" = {
      security_rules = [
        {
          name                       = "allow-app-port"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "8080"
          source_address_prefix      = "10.0.1.0/24"
          destination_address_prefix = "*"
        }
      ]
      associated_subnets = ["subnet-app"]
    }
  }

  # Route Tables
  route_tables = {
    "rt-database" = {
      disable_bgp_route_propagation = false
      routes = [
        {
          name                   = "route-to-firewall"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.100.4"
        }
      ]
      associated_subnets = ["subnet-database"]
    }
  }

  tags = var.tags
}
