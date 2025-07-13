# Exemplo com VNET Peering - Azure Network Module

Este exemplo demonstra como configurar VNET Peering entre múltiplas redes virtuais usando o módulo Azure Network.

## Recursos Criados

- 2 Virtual Networks (Hub e Spoke)
- 4 Subnets (2 em cada VNET)
- VNET Peering bidirecional entre Hub e Spoke
- Network Security Groups
- Route Tables para roteamento através do Hub

## Arquitetura

```
Hub VNET: 10.0.0.0/16
├── subnet-firewall: 10.0.1.0/24
└── subnet-shared: 10.0.2.0/24
    │
    │ VNET Peering
    │
Spoke VNET: 10.1.0.0/16
├── subnet-web: 10.1.1.0/24
└── subnet-app: 10.1.2.0/24
```

## Casos de Uso

- Arquitetura Hub-Spoke
- Conectividade entre ambientes
- Centralização de serviços compartilhados
- Roteamento através de appliances de rede

## Como usar

1. Configure suas credenciais Azure:
   ```bash
   az login
   ```

2. Copie o arquivo de exemplo:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Edite as variáveis conforme necessário:
   ```bash
   nano terraform.tfvars
   ```

4. Inicialize e aplique:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Validação

Após o deployment, você pode validar a conectividade:

```bash
# Verificar status do peering
az network vnet peering list --resource-group rg-peering-example --vnet-name vnet-hub --output table
az network vnet peering list --resource-group rg-peering-example --vnet-name vnet-spoke --output table

# Testar conectividade (se houver VMs deployadas)
# ping entre subnets das diferentes VNETs
```
