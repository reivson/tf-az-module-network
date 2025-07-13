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

output "resource_group_name" {
  description = "Nome do Resource Group criado"
  value       = azurerm_resource_group.example.name
}
