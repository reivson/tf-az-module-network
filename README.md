# Azure Network Module

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/)

Um módulo Terraform abrangente para criar e gerenciar recursos de rede no Microsoft Azure, incluindo Virtual Networks (VNETs), subnets, NAT Gateways, Network Security Groups, Route Tables e VNET Peering.

## 🚀 Recursos

- ✅ **Virtual Network (VNET)** com espaços de endereçamento customizáveis
- ✅ **Subnets** com configurações flexíveis de service endpoints e delegações
- ✅ **NAT Gateway** para conectividade de saída
- ✅ **Network Security Groups (NSGs)** com regras personalizáveis
- ✅ **Route Tables** com rotas customizadas
- ✅ **VNET Peering** para conectividade entre redes
- ✅ **Service Endpoints** para integração com serviços Azure
- ✅ **Subnet Delegation** para serviços específicos
- ✅ **Private Endpoints** suportados
- ✅ **Tags** para organização e governança

## 📋 Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) >= 2.0
- Provider `azurerm` >= 3.0

## 🏗️ Uso Básico

```hcl
module "network" {
  source = "git::https://github.com/seu-org/tf-az-module-network.git?ref=v1.0.0"

  resource_group_name = "rg-network"
  location           = "East US"
  vnet_name          = "vnet-production"
  vnet_address_space = ["10.0.0.0/16"]

  subnets = {
    "subnet-web" = {
      address_prefixes = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Storage"]
    }
    "subnet-db" = {
      address_prefixes = ["10.0.2.0/24"]
      service_endpoints = ["Microsoft.Sql"]
    }
  }

  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
```

## 📚 Exemplos

### Exemplo Básico
Configuração simples com VNET e subnets básicas.
- [Ver exemplo](./examples/basic/)

### Exemplo Completo
Configuração avançada com NAT Gateway, NSGs, Route Tables e VNET Peering.
- [Ver exemplo](./examples/complete/)

### Exemplo com Peering
Configuração de VNET Peering entre múltiplas redes.
- [Ver exemplo](./examples/with-peering/)

## 🔧 Configuração Avançada

### NAT Gateway

```hcl
nat_gateway = {
  enabled                 = true
  name                   = "nat-gw-production"
  idle_timeout_in_minutes = 10
  public_ip_count        = 2
  associated_subnets     = ["subnet-web", "subnet-app"]
}
```

### Network Security Groups

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
      }
    ]
    associated_subnets = ["subnet-web"]
  }
}
```

### Delegação de Subnet

```hcl
subnets = {
  "subnet-sql" = {
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
```

## 📊 Inputs

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-----------|------|--------|:-----------:|
| resource_group_name | Nome do Resource Group | `string` | n/a | ✅ |
| location | Localização dos recursos | `string` | n/a | ✅ |
| vnet_name | Nome da Virtual Network | `string` | n/a | ✅ |
| vnet_address_space | Espaço de endereçamento da VNET | `list(string)` | `["10.0.0.0/16"]` | ❌ |
| subnets | Configuração das subnets | `map(object)` | `{}` | ❌ |
| nat_gateway | Configuração do NAT Gateway | `object` | `{enabled = false}` | ❌ |
| network_security_groups | Configuração dos NSGs | `map(object)` | `{}` | ❌ |
| route_tables | Configuração das Route Tables | `map(object)` | `{}` | ❌ |
| peering_connections | Configuração do VNET Peering | `map(object)` | `{}` | ❌ |
| tags | Tags para os recursos | `map(string)` | `{}` | ❌ |

Para detalhes completos dos inputs, consulte [variables.tf](./variables.tf).

## 📤 Outputs

| Nome | Descrição |
|------|-----------|
| vnet_id | ID da Virtual Network |
| vnet_name | Nome da Virtual Network |
| subnet_ids | IDs das subnets criadas |
| nat_gateway_id | ID do NAT Gateway |
| network_security_group_ids | IDs dos Network Security Groups |
| route_table_ids | IDs das Route Tables |
| peering_ids | IDs das conexões de peering |

Para detalhes completos dos outputs, consulte [outputs.tf](./outputs.tf).

## 📚 Documentação Técnica

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## 🏷️ Versionamento

Este módulo segue [Semantic Versioning](https://semver.org/). Para as versões disponíveis, veja as [tags neste repositório](https://github.com/seu-org/tf-az-module-network/tags).

### Versões Suportadas

| Versão | Status | Terraform | AzureRM Provider |
|--------|--------|-----------|------------------|
| v1.x   | ✅ Ativa | >= 1.0 | >= 3.0 |

## 🤝 Contribuição

Contribuições são bem-vindas! Por favor, leia o [CONTRIBUTING.md](./CONTRIBUTING.md) para detalhes sobre nosso código de conduta e o processo para enviar pull requests.

## 🔒 Segurança

Para relatar vulnerabilidades de segurança, por favor siga as instruções em [SECURITY.md](./SECURITY.md).

## 📝 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](./LICENSE) para detalhes.

## 🆘 Suporte

- 📖 [Documentação](./docs/)
- 🐛 [Issues](https://github.com/seu-org/tf-az-module-network/issues)
- 💬 [Discussions](https://github.com/seu-org/tf-az-module-network/discussions)

## 📈 Roadmap

- [ ] Suporte para Azure Firewall
- [ ] Integração com Azure Bastion
- [ ] Suporte para Virtual Network Gateway
- [ ] Templates de arquitetura Hub-Spoke

---

**Mantido por:** DevOps Team
**Criado em:** 2025
