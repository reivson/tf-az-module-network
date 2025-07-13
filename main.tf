# Virtual Network
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  dns_servers         = length(var.dns_servers) > 0 ? var.dns_servers : null

  tags = var.tags
}

# Subnets
resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints

  private_endpoint_network_policies             = each.value.private_endpoint_network_policies_enabled ? "Enabled" : "Disabled"
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

# Public IPs for NAT Gateway
resource "azurerm_public_ip" "nat_gateway" {
  count = var.nat_gateway.enabled ? var.nat_gateway.public_ip_count : 0

  name                = "${var.nat_gateway.name != null ? var.nat_gateway.name : "${var.vnet_name}-nat-gw"}-pip-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# NAT Gateway
resource "azurerm_nat_gateway" "this" {
  count = var.nat_gateway.enabled ? 1 : 0

  name                    = var.nat_gateway.name != null ? var.nat_gateway.name : "${var.vnet_name}-nat-gw"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = var.nat_gateway.sku_name
  idle_timeout_in_minutes = var.nat_gateway.idle_timeout_in_minutes

  tags = var.tags
}

# Associate Public IPs to NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "this" {
  count = var.nat_gateway.enabled ? var.nat_gateway.public_ip_count : 0

  nat_gateway_id       = azurerm_nat_gateway.this[0].id
  public_ip_address_id = azurerm_public_ip.nat_gateway[count.index].id
}

# Associate NAT Gateway to Subnets
resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = var.nat_gateway.enabled ? toset(var.nat_gateway.associated_subnets) : []

  subnet_id      = azurerm_subnet.this[each.value].id
  nat_gateway_id = azurerm_nat_gateway.this[0].id
}

# Network Security Groups
resource "azurerm_network_security_group" "this" {
  for_each = var.network_security_groups

  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags

  dynamic "security_rule" {
    for_each = each.value.security_rules
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = security_rule.value.source_port_range
      destination_port_range       = security_rule.value.destination_port_range
      source_port_ranges           = security_rule.value.source_port_ranges
      destination_port_ranges      = security_rule.value.destination_port_ranges
      source_address_prefix        = security_rule.value.source_address_prefix
      destination_address_prefix   = security_rule.value.destination_address_prefix
      source_address_prefixes      = security_rule.value.source_address_prefixes
      destination_address_prefixes = security_rule.value.destination_address_prefixes
    }
  }
}

# Associate NSGs to Subnets
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for nsg_name, nsg_config in var.network_security_groups : nsg_name => nsg_config
    if length(nsg_config.associated_subnets) > 0
  }

  network_security_group_id = azurerm_network_security_group.this[each.key].id
  subnet_id                 = azurerm_subnet.this[each.value.associated_subnets[0]].id
}

# Route Tables
resource "azurerm_route_table" "this" {
  for_each = var.route_tables

  name                          = each.key
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = !each.value.disable_bgp_route_propagation

  tags = var.tags

  dynamic "route" {
    for_each = each.value.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
}

# Associate Route Tables to Subnets
resource "azurerm_subnet_route_table_association" "this" {
  for_each = {
    for rt_name, rt_config in var.route_tables : rt_name => rt_config
    if length(rt_config.associated_subnets) > 0
  }

  subnet_id      = azurerm_subnet.this[each.value.associated_subnets[0]].id
  route_table_id = azurerm_route_table.this[each.key].id
}

# VNET Peering
resource "azurerm_virtual_network_peering" "this" {
  for_each = var.peering_connections

  name                      = each.key
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value.remote_virtual_network_id

  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
}
