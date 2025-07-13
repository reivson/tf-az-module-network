output "vnet_id" {
  description = "ID da Virtual Network criada"
  value       = module.network.vnet_id
}

output "vnet_name" {
  description = "Nome da Virtual Network criada"
  value       = module.network.vnet_name
}

output "subnet_ids" {
  description = "IDs das subnets criadas"
  value       = module.network.subnet_ids
}

output "nat_gateway_id" {
  description = "ID do NAT Gateway criado"
  value       = module.network.nat_gateway_id
}

output "nat_gateway_public_ip_ids" {
  description = "IDs dos Public IPs do NAT Gateway"
  value       = module.network.nat_gateway_public_ip_ids
}

output "network_security_group_ids" {
  description = "IDs dos Network Security Groups criados"
  value       = module.network.network_security_group_ids
}

output "route_table_ids" {
  description = "IDs das Route Tables criadas"
  value       = module.network.route_table_ids
}

output "resource_group_name" {
  description = "Nome do Resource Group criado"
  value       = azurerm_resource_group.example.name
}
