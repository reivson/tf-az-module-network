output "hub_vnet_id" {
  description = "ID da Hub Virtual Network"
  value       = module.hub_network.vnet_id
}

output "hub_vnet_name" {
  description = "Nome da Hub Virtual Network"
  value       = module.hub_network.vnet_name
}

output "hub_subnet_ids" {
  description = "IDs das subnets da Hub VNET"
  value       = module.hub_network.subnet_ids
}

output "spoke_vnet_id" {
  description = "ID da Spoke Virtual Network"
  value       = module.spoke_network.vnet_id
}

output "spoke_vnet_name" {
  description = "Nome da Spoke Virtual Network"
  value       = module.spoke_network.vnet_name
}

output "spoke_subnet_ids" {
  description = "IDs das subnets da Spoke VNET"
  value       = module.spoke_network.subnet_ids
}

output "peering_connections" {
  description = "IDs das conexões de peering"
  value = {
    spoke_to_hub = module.spoke_network.peering_ids["peer-spoke-to-hub"]
    hub_to_spoke = azurerm_virtual_network_peering.hub_to_spoke.id
  }
}

output "network_security_group_ids" {
  description = "IDs dos Network Security Groups"
  value = {
    hub   = module.hub_network.network_security_group_ids
    spoke = module.spoke_network.network_security_group_ids
  }
}

output "route_table_ids" {
  description = "IDs das Route Tables"
  value = {
    spoke = module.spoke_network.route_table_ids
  }
}

output "resource_group_name" {
  description = "Nome do Resource Group criado"
  value       = azurerm_resource_group.example.name
}
