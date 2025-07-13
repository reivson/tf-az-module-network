package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBasicExample(t *testing.T) {
	t.Parallel()

	// Configuração do Terraform
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../examples/basic",
		VarFiles:     []string{"terraform.tfvars.example"},
		Vars: map[string]interface{}{
			"resource_group_name": "rg-terratest-basic-" + generateRandomString(8),
			"vnet_name":           "vnet-terratest-basic-" + generateRandomString(8),
		},
	})

	// Limpa recursos no final do teste
	defer terraform.Destroy(t, terraformOptions)

	// Executa terraform init e apply
	terraform.InitAndApply(t, terraformOptions)

	// Valida outputs
	vnetId := terraform.Output(t, terraformOptions, "vnet_id")
	vnetName := terraform.Output(t, terraformOptions, "vnet_name")
	subnetIds := terraform.OutputMap(t, terraformOptions, "subnet_ids")

	// Assertions
	assert.NotEmpty(t, vnetId)
	assert.NotEmpty(t, vnetName)
	assert.Contains(t, subnetIds, "subnet-web")
	assert.Contains(t, subnetIds, "subnet-database")
}

func TestCompleteExample(t *testing.T) {
	t.Parallel()

	// Configuração do Terraform
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../examples/complete",
		VarFiles:     []string{"terraform.tfvars.example"},
		Vars: map[string]interface{}{
			"resource_group_name": "rg-terratest-complete-" + generateRandomString(8),
			"vnet_name":           "vnet-terratest-complete-" + generateRandomString(8),
		},
	})

	// Limpa recursos no final do teste
	defer terraform.Destroy(t, terraformOptions)

	// Executa terraform init e apply
	terraform.InitAndApply(t, terraformOptions)

	// Valida outputs
	vnetId := terraform.Output(t, terraformOptions, "vnet_id")
	natGatewayId := terraform.Output(t, terraformOptions, "nat_gateway_id")
	nsgIds := terraform.OutputMap(t, terraformOptions, "network_security_group_ids")
	routeTableIds := terraform.OutputMap(t, terraformOptions, "route_table_ids")

	// Assertions
	assert.NotEmpty(t, vnetId)
	assert.NotEmpty(t, natGatewayId)
	assert.Contains(t, nsgIds, "nsg-web")
	assert.Contains(t, nsgIds, "nsg-app")
	assert.Contains(t, routeTableIds, "rt-database")
}

func TestWithPeeringExample(t *testing.T) {
	t.Parallel()

	// Configuração do Terraform
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../examples/with-peering",
		VarFiles:     []string{"terraform.tfvars.example"},
		Vars: map[string]interface{}{
			"resource_group_name": "rg-terratest-peering-" + generateRandomString(8),
			"hub_vnet_name":       "vnet-hub-" + generateRandomString(8),
			"spoke_vnet_name":     "vnet-spoke-" + generateRandomString(8),
		},
	})

	// Limpa recursos no final do teste
	defer terraform.Destroy(t, terraformOptions)

	// Executa terraform init e apply
	terraform.InitAndApply(t, terraformOptions)

	// Valida outputs
	hubVnetId := terraform.Output(t, terraformOptions, "hub_vnet_id")
	spokeVnetId := terraform.Output(t, terraformOptions, "spoke_vnet_id")
	peeringConnections := terraform.OutputMap(t, terraformOptions, "peering_connections")

	// Assertions
	assert.NotEmpty(t, hubVnetId)
	assert.NotEmpty(t, spokeVnetId)
	assert.Contains(t, peeringConnections, "spoke_to_hub")
	assert.Contains(t, peeringConnections, "hub_to_spoke")
}

func generateRandomString(length int) string {
	// Implementação para gerar string aleatória
	// Por simplicidade, retornando valor fixo para exemplo
	return "test123"
}
