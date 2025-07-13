output "vnet_id" {
  description = "ID da Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Nome da Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "vnet_address_space" {
  description = "Espaço de endereçamento da Virtual Network"
  value       = azurerm_virtual_network.this.address_space
}

output "vnet_location" {
  description = "Localização da Virtual Network"
  value       = azurerm_virtual_network.this.location
}

output "vnet_resource_group_name" {
  description = "Nome do Resource Group da Virtual Network"
  value       = azurerm_virtual_network.this.resource_group_name
}

output "subnet_ids" {
  description = "IDs das subnets criadas"
  value = {
    for subnet_name, subnet in azurerm_subnet.this : subnet_name => subnet.id
  }
}

output "subnet_names" {
  description = "Nomes das subnets criadas"
  value = {
    for subnet_name, subnet in azurerm_subnet.this : subnet_name => subnet.name
  }
}

output "subnet_address_prefixes" {
  description = "Address prefixes das subnets"
  value = {
    for subnet_name, subnet in azurerm_subnet.this : subnet_name => subnet.address_prefixes
  }
}

output "nat_gateway_id" {
  description = "ID do NAT Gateway (se criado)"
  value       = var.nat_gateway.enabled ? azurerm_nat_gateway.this[0].id : null
}

output "nat_gateway_public_ip_ids" {
  description = "IDs dos Public IPs do NAT Gateway"
  value       = var.nat_gateway.enabled ? azurerm_public_ip.nat_gateway[*].id : []
}

output "network_security_group_ids" {
  description = "IDs dos Network Security Groups"
  value = {
    for nsg_name, nsg in azurerm_network_security_group.this : nsg_name => nsg.id
  }
}

output "route_table_ids" {
  description = "IDs das Route Tables"
  value = {
    for rt_name, rt in azurerm_route_table.this : rt_name => rt.id
  }
}

output "peering_ids" {
  description = "IDs das conexões de peering"
  value = {
    for peer_name, peer in azurerm_virtual_network_peering.this : peer_name => peer.id
  }
}
