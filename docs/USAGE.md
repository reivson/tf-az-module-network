# Guia de Uso - Azure Network Module

Este guia fornece exemplos detalhados e práticos de como usar o módulo Azure Network.

## 📋 Índice

- [Configuração Inicial](#configuração-inicial)
- [Exemplos Básicos](#exemplos-básicos)
- [Configurações Avançadas](#configurações-avançadas)
- [Casos de Uso Comuns](#casos-de-uso-comuns)
- [Troubleshooting](#troubleshooting)

## 🚀 Configuração Inicial

### Pré-requisitos

1. **Terraform instalado** (>= 1.0)
2. **Azure CLI configurado**
3. **Permissões adequadas no Azure**

### Autenticação

```bash
# Login no Azure
az login

# Definir subscription (opcional)
az account set --subscription "sua-subscription-id"
```

## 📝 Exemplos Básicos

### 1. VNET Simples

```hcl
module "network" {
  source = "git::https://github.com/seu-org/tf-az-module-network.git?ref=v1.0.0"

  resource_group_name = "rg-production"
  location           = "East US"
  vnet_name          = "vnet-production"
  vnet_address_space = ["10.0.0.0/16"]

  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
```

### 2. VNET com Subnets

```hcl
module "network" {
  source = "git::https://github.com/seu-org/tf-az-module-network.git?ref=v1.0.0"

  resource_group_name = "rg-production"
  location           = "East US"
  vnet_name          = "vnet-production"
  vnet_address_space = ["10.0.0.0/16"]

  subnets = {
    "subnet-web" = {
      address_prefixes = ["10.0.1.0/24"]
    }
    "subnet-database" = {
      address_prefixes = ["10.0.2.0/24"]
    }
  }

  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
```

## 🔧 Configurações Avançadas

### 1. VNET com NAT Gateway

```hcl
module "network" {
  source = "git::https://github.com/seu-org/tf-az-module-network.git?ref=v1.0.0"

  resource_group_name = "rg-production"
  location           = "East US"
  vnet_name          = "vnet-production"
  vnet_address_space = ["10.0.0.0/16"]

  subnets = {
    "subnet-web" = {
      address_prefixes = ["10.0.1.0/24"]
    }
    "subnet-app" = {
      address_prefixes = ["10.0.2.0/24"]
    }
  }

  nat_gateway = {
    enabled                 = true
    name                   = "nat-gw-production"
    idle_timeout_in_minutes = 10
    public_ip_count        = 2
    associated_subnets     = ["subnet-web", "subnet-app"]
  }

  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
```

### 2. Network Security Groups

```hcl
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
        name                       = "deny-all-inbound"
        priority                   = 4000
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    associated_subnets = ["subnet-web"]
  }
}
```

### 3. Route Tables

```hcl
route_tables = {
  "rt-app" = {
    disable_bgp_route_propagation = false
    routes = [
      {
        name           = "route-to-firewall"
        address_prefix = "0.0.0.0/0"
        next_hop_type  = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.100.4"
      },
      {
        name           = "route-to-onpremises"
        address_prefix = "192.168.0.0/16"
        next_hop_type  = "VirtualNetworkGateway"
      }
    ]
    associated_subnets = ["subnet-app"]
  }
}
```

### 4. Service Endpoints

```hcl
subnets = {
  "subnet-app" = {
    address_prefixes = ["10.0.2.0/24"]
    service_endpoints = [
      "Microsoft.Storage",
      "Microsoft.Sql",
      "Microsoft.KeyVault",
      "Microsoft.EventHub",
      "Microsoft.ServiceBus"
    ]
  }
}
```

### 5. Subnet Delegation

```hcl
subnets = {
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
  "subnet-aks" = {
    address_prefixes = ["10.0.20.0/24"]
    delegation = {
      name = "aks-delegation"
      service_delegation = {
        name = "Microsoft.ContainerService/managedClusters"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action"
        ]
      }
    }
  }
}
```

### 6. VNET Peering

```hcl
peering_connections = {
  "peer-to-hub" = {
    remote_virtual_network_id    = "/subscriptions/xxx/resourceGroups/rg-hub/providers/Microsoft.Network/virtualNetworks/vnet-hub"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = true
  }
}
```

## 🏗️ Casos de Uso Comuns

### Arquitetura Hub-Spoke

```hcl
# Hub Network
module "hub_network" {
  source = "git::https://github.com/seu-org/tf-az-module-network.git?ref=v1.0.0"

  resource_group_name = "rg-hub"
  location           = "East US"
  vnet_name          = "vnet-hub"
  vnet_address_space = ["10.0.0.0/16"]

  subnets = {
    "subnet-firewall" = {
      address_prefixes = ["10.0.1.0/24"]
    }
    "subnet-gateway" = {
      address_prefixes = ["10.0.2.0/24"]
    }
  }

  tags = {
    Environment = "Shared"
    Role        = "Hub"
  }
}

# Spoke Network
module "spoke_network" {
  source = "git::https://github.com/seu-org/tf-az-module-network.git?ref=v1.0.0"

  resource_group_name = "rg-spoke-prod"
  location           = "East US"
  vnet_name          = "vnet-spoke-prod"
  vnet_address_space = ["10.1.0.0/16"]

  subnets = {
    "subnet-web" = {
      address_prefixes = ["10.1.1.0/24"]
    }
    "subnet-app" = {
      address_prefixes = ["10.1.2.0/24"]
    }
  }

  peering_connections = {
    "peer-to-hub" = {
      remote_virtual_network_id = module.hub_network.vnet_id
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      use_remote_gateways          = true
    }
  }

  route_tables = {
    "rt-spoke" = {
      routes = [
        {
          name           = "route-to-hub"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.1.4" # Firewall IP
        }
      ]
      associated_subnets = ["subnet-web", "subnet-app"]
    }
  }

  tags = {
    Environment = "Production"
    Role        = "Spoke"
  }
}
```

### Ambiente para Kubernetes (AKS)

```hcl
module "aks_network" {
  source = "git::https://github.com/seu-org/tf-az-module-network.git?ref=v1.0.0"

  resource_group_name = "rg-aks"
  location           = "East US"
  vnet_name          = "vnet-aks"
  vnet_address_space = ["10.2.0.0/16"]

  subnets = {
    "subnet-aks-nodes" = {
      address_prefixes = ["10.2.1.0/24"]
      delegation = {
        name = "aks-delegation"
        service_delegation = {
          name = "Microsoft.ContainerService/managedClusters"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action"
          ]
        }
      }
    }
    "subnet-aks-pods" = {
      address_prefixes = ["10.2.2.0/23"]
    }
    "subnet-app-gateway" = {
      address_prefixes = ["10.2.10.0/24"]
    }
  }

  nat_gateway = {
    enabled                 = true
    name                   = "nat-gw-aks"
    associated_subnets     = ["subnet-aks-nodes"]
  }

  network_security_groups = {
    "nsg-aks" = {
      security_rules = [
        {
          name                       = "allow-https"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
      associated_subnets = ["subnet-app-gateway"]
    }
  }

  tags = {
    Environment = "Production"
    Service     = "AKS"
  }
}
```

## 🔍 Troubleshooting

### Problemas Comuns

#### 1. Erro de Address Space Overlap

**Erro**: `Address space overlaps with existing subnet`

**Solução**:
- Verifique se os address_prefixes não se sobrepõem
- Use ferramentas de calculadora de subnet
- Planeje adequadamente o espaço de endereçamento

#### 2. Delegação de Subnet Falhando

**Erro**: `Subnet delegation failed`

**Solução**:
- Verifique se o serviço suporta delegação
- Confirme as actions necessárias para o serviço
- Certifique-se de que a subnet está vazia

#### 3. NAT Gateway não Funcionando

**Erro**: Tráfego de saída não está funcionando

**Solução**:
- Verifique se a subnet está associada ao NAT Gateway
- Confirme se o Public IP está anexado
- Verifique route tables que podem estar sobrescrevendo

### Validação de Configuração

```bash
# Validar sintaxe
terraform fmt -check -recursive
terraform validate

# Executar plan para verificar mudanças
terraform plan

# Verificar recursos no Azure
az network vnet list --output table
az network nsg list --output table
```

### Monitoramento

Use Azure Monitor e Network Watcher para monitorar:
- Conectividade entre subnets
- Tráfego através do NAT Gateway
- Regras de NSG aplicadas
- Performance da rede

## 📚 Recursos Adicionais

- [Documentação oficial do Azure Virtual Network](https://docs.microsoft.com/azure/virtual-network/)
- [Best practices para arquitetura de rede no Azure](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/)
- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
