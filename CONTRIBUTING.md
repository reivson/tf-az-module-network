# Contribuindo para o Azure Network Module

Obrigado por seu interesse em contribuir! Este documento fornece diretrizes para contribuir com o projeto.

## 🚀 Como Contribuir

### Reportando Bugs

1. Verifique se o bug já foi reportado nas [Issues](https://github.com/seu-org/tf-az-module-network/issues)
2. Se não encontrou, crie uma nova issue usando o template de bug report
3. Inclua informações detalhadas:
   - Versão do Terraform
   - Versão do provider azurerm
   - Configuração que causou o problema
   - Logs de erro completos

### Sugerindo Melhorias

1. Verifique se a sugestão já foi discutida nas [Discussions](https://github.com/seu-org/tf-az-module-network/discussions)
2. Crie uma nova issue usando o template de feature request
3. Descreva claramente:
   - O problema que a feature resolve
   - A solução proposta
   - Alternativas consideradas

### Enviando Pull Requests

1. Fork o repositório
2. Crie uma branch para sua feature: `git checkout -b feature/nova-funcionalidade`
3. Faça suas alterações seguindo as diretrizes de código
4. Teste suas alterações
5. Commit suas mudanças: `git commit -m 'feat: adiciona nova funcionalidade'`
6. Push para a branch: `git push origin feature/nova-funcionalidade`
7. Abra um Pull Request

## 📝 Diretrizes de Código

### Terraform

- Use nomes de variáveis descritivos em português
- Inclua descrições detalhadas para todas as variáveis
- Use tipos de dados específicos em vez de `any`
- Adicione validações quando apropriado
- Mantenha a formatação consistente: `terraform fmt`

### Exemplo de Variável

```hcl
variable "subnet_configs" {
  description = "Configuração das subnets com service endpoints e delegações"
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string))
      })
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for subnet_name, subnet in var.subnet_configs : 
      length(subnet.address_prefixes) > 0
    ])
    error_message = "Cada subnet deve ter pelo menos um address_prefix definido."
  }
}
```

### Documentação

- Mantenha o README.md atualizado
- Adicione exemplos para novas funcionalidades
- Use comentários no código quando necessário
- Documente breaking changes no CHANGELOG.md

### Commits

Use [Conventional Commits](https://conventionalcommits.org/):

- `feat:` para novas funcionalidades
- `fix:` para correções de bugs
- `docs:` para mudanças na documentação
- `style:` para formatação, sem mudanças de código
- `refactor:` para refatoração de código
- `test:` para adição ou modificação de testes
- `chore:` para tarefas de manutenção

### Testes

Antes de enviar um PR:

1. Execute `terraform fmt -check -recursive`
2. Execute `terraform validate` no módulo principal
3. Execute `terraform validate` em todos os exemplos
4. Teste localmente com configurações reais (quando possível)

## 🏗️ Estrutura do Projeto

```
tf-az-module-network/
├── main.tf              # Recursos principais
├── variables.tf         # Definições de variáveis
├── outputs.tf          # Definições de outputs
├── versions.tf         # Versões e providers
├── README.md           # Documentação principal
├── CHANGELOG.md        # Histórico de mudanças
├── examples/           # Exemplos de uso
│   ├── basic/         # Exemplo básico
│   └── complete/      # Exemplo completo
├── .github/
│   └── workflows/     # CI/CD workflows
├── .pre-commit-config.yaml
├── .terraform-docs.yml
└── .gitignore
```

## 🔄 Processo de Review

1. **Revisão Automática**: CI/CD executa validações automáticas
2. **Revisão Manual**: Maintainers revisam o código e funcionalidade
3. **Testes**: Verificação se os exemplos funcionam
4. **Documentação**: Verificação se a documentação está atualizada

## 📋 Checklist para PRs

- [ ] Código formatado com `terraform fmt`
- [ ] Validação do Terraform passa
- [ ] Exemplos testados e funcionando
- [ ] Documentação atualizada
- [ ] CHANGELOG.md atualizado
- [ ] Testes de segurança passando
- [ ] Commit messages seguem padrão

## 🏷️ Versionamento

- **Major** (x.0.0): Breaking changes
- **Minor** (0.x.0): Novas funcionalidades (backward compatible)
- **Patch** (0.0.x): Bug fixes (backward compatible)

## 💬 Comunicação

- [Issues](https://github.com/seu-org/tf-az-module-network/issues) para bugs e features
- [Discussions](https://github.com/seu-org/tf-az-module-network/discussions) para perguntas e ideias
- [Slack/Teams] para comunicação rápida (se aplicável)

## 📞 Contato

- **Maintainers**: DevOps Team
- **Email**: devops@empresa.com

Obrigado por contribuir! 🎉
