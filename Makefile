.PHONY: help init validate plan apply destroy clean fmt docs test

# Variables
TERRAFORM_VERSION := 1.9.0
EXAMPLE := basic

help: ## Mostra esta ajuda
	@echo "Comandos disponíveis:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Inicializa o Terraform
	terraform init

validate: ## Valida a configuração do Terraform
	terraform fmt -check -recursive
	terraform validate

fmt: ## Formata os arquivos Terraform
	terraform fmt -recursive

docs: ## Gera documentação com terraform-docs
	terraform-docs markdown table --output-file README.md .

example-init: ## Inicializa exemplo específico (use EXAMPLE=nome)
	cd examples/$(EXAMPLE) && terraform init

example-validate: ## Valida exemplo específico
	cd examples/$(EXAMPLE) && terraform validate

example-plan: ## Executa plan no exemplo
	cd examples/$(EXAMPLE) && cp terraform.tfvars.example terraform.tfvars && terraform plan

example-apply: ## Aplica exemplo
	cd examples/$(EXAMPLE) && terraform apply -auto-approve

example-destroy: ## Destroi recursos do exemplo
	cd examples/$(EXAMPLE) && terraform destroy -auto-approve

example-clean: ## Limpa arquivos temporários do exemplo
	cd examples/$(EXAMPLE) && rm -rf .terraform terraform.tfstate* terraform.tfvars .terraform.lock.hcl

validate-all: ## Valida módulo principal e todos os exemplos
	@echo "Validando módulo principal..."
	make validate
	@echo "Validando exemplo basic..."
	make example-validate EXAMPLE=basic
	@echo "Validando exemplo complete..."
	make example-validate EXAMPLE=complete
	@echo "Validando exemplo with-peering..."
	make example-validate EXAMPLE=with-peering

test-basic: ## Testa exemplo básico
	make example-init EXAMPLE=basic
	make example-validate EXAMPLE=basic
	make example-plan EXAMPLE=basic

test-with-peering: ## Testa exemplo with-peering
	make example-init EXAMPLE=with-peering
	make example-validate EXAMPLE=with-peering
	make example-plan EXAMPLE=with-peering

test-all: ## Executa todos os testes
	make test-basic
	make test-complete
	make test-with-peering

clean: ## Limpa todos os arquivos temporários
	rm -rf .terraform terraform.tfstate* .terraform.lock.hcl
	find examples -name ".terraform" -type d -exec rm -rf {} +
	find examples -name "terraform.tfstate*" -type f -delete
	find examples -name ".terraform.lock.hcl" -type f -delete
	find examples -name "terraform.tfvars" -type f -delete

security-scan: ## Executa scan de segurança
	@echo "Executando TfSec..."
	tfsec .
	@echo "Executando Checkov..."
	checkov -d . --framework terraform

pre-commit: ## Instala e executa pre-commit hooks
	pre-commit install
	pre-commit run --all-files

setup-dev: ## Configura ambiente de desenvolvimento
	@echo "Instalando pre-commit..."
	pip install pre-commit
	@echo "Instalando terraform-docs..."
	# Instruções para instalar terraform-docs dependem do SO
	@echo "Instalando tfsec..."
	# Instruções para instalar tfsec dependem do SO
	make pre-commit

version-patch: ## Incrementa versão patch (x.x.X)
	@echo "Incrementando versão patch..."
	# Implementar lógica de versionamento

version-minor: ## Incrementa versão minor (x.X.x)
	@echo "Incrementando versão minor..."
	# Implementar lógica de versionamento

version-major: ## Incrementa versão major (X.x.x)
	@echo "Incrementando versão major..."
	# Implementar lógica de versionamento

release: ## Cria release (após incrementar versão)
	@echo "Criando release..."
	git add -A
	git commit -m "chore: release version"
	git tag -a v$(VERSION) -m "Release version $(VERSION)"
	git push origin main --tags
