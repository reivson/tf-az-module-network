# Exemplo Básico - Azure Network Module

Este exemplo demonstra o uso básico do módulo para criar uma VNET simples com duas subnets.

## Recursos Criados

- 1 Virtual Network
- 2 Subnets (web e database)
- Service Endpoints configurados

## Como usar

1. Configure suas credenciais Azure:
   ```bash
   az login
   ```

2. Inicialize o Terraform:
   ```bash
   terraform init
   ```

3. Revise o plano:
   ```bash
   terraform plan
   ```

4. Aplique a configuração:
   ```bash
   terraform apply
   ```

## Estrutura de Rede

```
VNET: 10.0.0.0/16
├── subnet-web: 10.0.1.0/24
└── subnet-database: 10.0.2.0/24
```
