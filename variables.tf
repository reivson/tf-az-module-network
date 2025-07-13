variable "resource_group_name" {
  description = "Nome do Resource Group onde os recursos serão criados"
  type        = string
}

variable "location" {
  description = "Localização dos recursos Azure"
  type        = string
}

variable "vnet_name" {
  description = "Nome da Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "Espaço de endereçamento da VNET"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "dns_servers" {
  description = "Lista de servidores DNS personalizados"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "Configuração das subnets"
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
    private_endpoint_network_policies_enabled     = optional(bool, true)
    private_link_service_network_policies_enabled = optional(bool, true)
  }))
  default = {}
}

variable "peering_connections" {
  description = "Configuração de VNET Peering"
  type = map(object({
    remote_virtual_network_id    = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, false)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
  default = {}
}

variable "nat_gateway" {
  description = "Configuração do NAT Gateway"
  type = object({
    enabled                 = bool
    name                    = optional(string)
    idle_timeout_in_minutes = optional(number, 4)
    sku_name                = optional(string, "Standard")
    public_ip_count         = optional(number, 1)
    associated_subnets      = optional(list(string), [])
  })
  default = {
    enabled = false
  }
}

variable "network_security_groups" {
  description = "Configuração dos Network Security Groups"
  type = map(object({
    security_rules = optional(list(object({
      name                         = string
      priority                     = number
      direction                    = string
      access                       = string
      protocol                     = string
      source_port_range            = optional(string)
      destination_port_range       = optional(string)
      source_port_ranges           = optional(list(string))
      destination_port_ranges      = optional(list(string))
      source_address_prefix        = optional(string)
      destination_address_prefix   = optional(string)
      source_address_prefixes      = optional(list(string))
      destination_address_prefixes = optional(list(string))
    })), [])
    associated_subnets = optional(list(string), [])
  }))
  default = {}
}

variable "route_tables" {
  description = "Configuração das Route Tables"
  type = map(object({
    disable_bgp_route_propagation = optional(bool, false)
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), [])
    associated_subnets = optional(list(string), [])
  }))
  default = {}
}

variable "tags" {
  description = "Tags para aplicar aos recursos"
  type        = map(string)
  default     = {}
}
