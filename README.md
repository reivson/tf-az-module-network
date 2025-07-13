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
## Requirements

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0 |

## Providers

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0 |

## Modules

## Modules

No modules.

## Resources

## Resources

| Name | Type |
|------|------|
| [azurerm_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.nat_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | Lista de servidores DNS personalizados | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Localização dos recursos Azure | `string` | n/a | yes |
| <a name="input_nat_gateway"></a> [nat\_gateway](#input\_nat\_gateway) | Configuração do NAT Gateway | <pre>object({<br/>    enabled                 = bool<br/>    name                    = optional(string)<br/>    idle_timeout_in_minutes = optional(number, 4)<br/>    sku_name                = optional(string, "Standard")<br/>    public_ip_count         = optional(number, 1)<br/>    associated_subnets      = optional(list(string), [])<br/>  })</pre> | <pre>{<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | Configuração dos Network Security Groups | <pre>map(object({<br/>    security_rules = optional(list(object({<br/>      name                         = string<br/>      priority                     = number<br/>      direction                    = string<br/>      access                       = string<br/>      protocol                     = string<br/>      source_port_range            = optional(string)<br/>      destination_port_range       = optional(string)<br/>      source_port_ranges           = optional(list(string))<br/>      destination_port_ranges      = optional(list(string))<br/>      source_address_prefix        = optional(string)<br/>      destination_address_prefix   = optional(string)<br/>      source_address_prefixes      = optional(list(string))<br/>      destination_address_prefixes = optional(list(string))<br/>    })), [])<br/>    associated_subnets = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_peering_connections"></a> [peering\_connections](#input\_peering\_connections) | Configuração de VNET Peering | <pre>map(object({<br/>    remote_virtual_network_id    = string<br/>    allow_virtual_network_access = optional(bool, true)<br/>    allow_forwarded_traffic      = optional(bool, false)<br/>    allow_gateway_transit        = optional(bool, false)<br/>    use_remote_gateways          = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Nome do Resource Group onde os recursos serão criados | `string` | n/a | yes |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Configuração das Route Tables | <pre>map(object({<br/>    disable_bgp_route_propagation = optional(bool, false)<br/>    routes = optional(list(object({<br/>      name                   = string<br/>      address_prefix         = string<br/>      next_hop_type          = string<br/>      next_hop_in_ip_address = optional(string)<br/>    })), [])<br/>    associated_subnets = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Configuração das subnets | <pre>map(object({<br/>    address_prefixes  = list(string)<br/>    service_endpoints = optional(list(string), [])<br/>    delegation = optional(object({<br/>      name = string<br/>      service_delegation = object({<br/>        name    = string<br/>        actions = optional(list(string))<br/>      })<br/>    }))<br/>    private_endpoint_network_policies_enabled     = optional(bool, true)<br/>    private_link_service_network_policies_enabled = optional(bool, true)<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags para aplicar aos recursos | `map(string)` | `{}` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | Espaço de endereçamento da VNET | `list(string)` | <pre>[<br/>  "10.0.0.0/16"<br/>]</pre> | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Nome da Virtual Network | `string` | n/a | yes |

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | ID do NAT Gateway (se criado) |
| <a name="output_nat_gateway_public_ip_ids"></a> [nat\_gateway\_public\_ip\_ids](#output\_nat\_gateway\_public\_ip\_ids) | IDs dos Public IPs do NAT Gateway |
| <a name="output_network_security_group_ids"></a> [network\_security\_group\_ids](#output\_network\_security\_group\_ids) | IDs dos Network Security Groups |
| <a name="output_peering_ids"></a> [peering\_ids](#output\_peering\_ids) | IDs das conexões de peering |
| <a name="output_route_table_ids"></a> [route\_table\_ids](#output\_route\_table\_ids) | IDs das Route Tables |
| <a name="output_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#output\_subnet\_address\_prefixes) | Address prefixes das subnets |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | IDs das subnets criadas |
| <a name="output_subnet_names"></a> [subnet\_names](#output\_subnet\_names) | Nomes das subnets criadas |
| <a name="output_vnet_address_space"></a> [vnet\_address\_space](#output\_vnet\_address\_space) | Espaço de endereçamento da Virtual Network |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | ID da Virtual Network |
| <a name="output_vnet_location"></a> [vnet\_location](#output\_vnet\_location) | Localização da Virtual Network |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | Nome da Virtual Network |
| <a name="output_vnet_resource_group_name"></a> [vnet\_resource\_group\_name](#output\_vnet\_resource\_group\_name) | Nome do Resource Group da Virtual Network |
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
