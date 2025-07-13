# Exemplo Completo - Azure Network Module

Este exemplo demonstra o uso completo do módulo com todas as funcionalidades:

- Virtual Network com múltiplas subnets
- NAT Gateway para conectividade de saída
- Network Security Groups com regras personalizadas
- Route Tables com rotas customizadas
- Service Endpoints e delegações de subnet

## Recursos Criados

- 1 Virtual Network
- 4 Subnets (web, app, database, management)
- 1 NAT Gateway com 2 Public IPs
- 2 Network Security Groups
- 1 Route Table
- Service Endpoints configurados
- Delegação de subnet para Azure SQL

## Arquitetura

```
VNET: 10.0.0.0/16
├── subnet-web: 10.0.1.0/24 (NSG: nsg-web, NAT Gateway)
├── subnet-app: 10.0.2.0/24 (NSG: nsg-app, NAT Gateway)
├── subnet-database: 10.0.3.0/24 (Route Table)
└── subnet-sql-mi: 10.0.10.0/24 (Delegated to SQL Managed Instance)
```

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
